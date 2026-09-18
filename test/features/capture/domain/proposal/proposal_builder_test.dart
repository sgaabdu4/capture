import 'package:capture/features/capture/domain/jev/boundary_pass.dart';
import 'package:capture/features/capture/domain/jev/classification_pass.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/features/capture/domain/proposal/edits.dart';
import 'package:capture/features/capture/domain/proposal/proposal_builder.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/assembly.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/titles.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const example =
    'I learned about Jev today. It could help organise my notes. I had a '
    'lovely evening with Sarah, and I thought of a meal-planning app. Remind '
    'me to buy groceries tomorrow at 2pm. Actually, make that 3pm.';

const groups = [
  Group(id: 'g-tech', name: 'Tech', description: 'Programming and AI'),
  Group(id: 'g-personal', name: 'Personal', description: 'Daily life'),
  Group(id: 'g-ideas', name: 'Ideas', description: 'Possible products'),
  Group(id: 'g-old', name: 'Old', description: 'Archived', archived: true),
  Group(id: 'g-unsorted', name: 'Unsorted', description: 'None fits'),
];

Map<String, Object?> choice(String c, [double confidence = 0.9]) => {
  'type': 'choice',
  'choice': c,
  'confidence': confidence,
  'probabilities': {c: 0.9},
};

Map<String, Object?> noul(double p) => {'type': 'noul', 'noul': p};

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('boundary questions name their unit in the instructions', () {
    final units = splitCandidates(example);
    final questions = boundaryQuestions(units);
    expect(questions.length, units.length - 1);
    for (final u in units.skip(1)) {
      final q = questions[boundaryKey(u)]!;
      expect(q.instructions, contains('unit ${u.id}'));
    }
    expect(boundaryState(units), contains('U001| I learned about Jev today.'));
  });

  test('decodeResponse validates types, ranges and option membership', () {
    final asked = <String, JevQuestion>{
      'a': const NoulQuestion('Is it?'),
      'b': ChoiceQuestion('Which?', {'x': 'X', 'y': 'Y'}),
    };
    final ok = decodeResponse({
      'model': 'jev-1.13.0',
      'answers': {'a': noul(0.2), 'b': choice('y', 0.5)},
      'usage': {'input_tokens': 10, 'output_tokens': 2},
    }, asked);
    expect((ok.answers['a']! as NoulAnswer).yes, 0.2);
    expect((ok.answers['b']! as ChoiceAnswer).choice, 'y');
    expect(ok.usage.inputTokens, 10);

    void bad(Map<String, Object?> answers) => expect(
      () => decodeResponse({'answers': answers}, asked),
      throwsA(isA<JevDecodeException>()),
    );
    bad({'a': noul(0.2)}); // missing b
    bad({'a': noul(1.5), 'b': choice('x')}); // out of range
    bad({'a': noul(0.5), 'b': choice('z')}); // not an option
    bad({'a': choice('x'), 'b': choice('x')}); // wrong type
    expect(() => decodeResponse('nope', asked), throwsA(isA<JevDecodeException>()));
  });

  test('batching keeps every question and repeats full state', () {
    final questions = {
      for (var i = 0; i < 400; i++) 'q$i': NoulQuestion('Question $i ${'padding ' * 60}'),
    };
    final batches = batchQuestions('state', questions);
    expect(batches.length, greaterThan(1));
    expect(batches.expand((b) => b.keys).toSet(), questions.keys.toSet());
    expect(
      () => batchQuestions('x' * 80000, {'a': const NoulQuestion('q')}),
      throwsA(isA<JevDecodeException>()),
    );
  });

  test('assembly accounts for every source passage exactly once', () {
    final units = splitCandidates(example);
    final decisions = {
      for (var i = 1; i < units.length; i++)
        i: BoundaryDecision(i.isEven, i == 3, i.isEven ? 0.8 : 0.2),
    };
    final thoughts = assembleThoughts(example, units, decisions);
    final inside = thoughts.expand((t) => t.units).map((u) => u.span);
    expect(coverageProblems(example, inside), isEmpty);
    expect(coverageProblems(example, thoughts.map((t) => t.span)), isEmpty);
    expect(thoughts.first.span.excerpt, startsWith('I learned about Jev today. It'));
    expect(thoughts.any((t) => t.uncertainStart), isTrue);
  });

  test('a late correction starts its own flagged item', () {
    const text =
        'Remind me to call mum at 5pm. Buy stamps. '
        'Oh, and make the call at 6pm instead.';
    final units = splitCandidates(text);
    expect(units, hasLength(3));
    expect(lateCorrectionQuestions(units).keys, ['late_U003']);
    final thoughts = assembleThoughts(text, units, {
      1: const BoundaryDecision(true, false, 0.9),
      2: const BoundaryDecision(false, false, 0.1, lateCorrection: true),
    });
    expect(thoughts, hasLength(3));
    expect(thoughts.last.lateCorrection, isTrue);
    expect(thoughts.last.span.excerpt, startsWith('Oh, and make the call'));
  });

  group('the brief example', () {
    late List<Thought> thoughts;
    late ClassificationPlan plan;
    late List<ProposalItem> items;

    setUp(() {
      final units = splitCandidates(example);
      expect(units.map((u) => u.span.excerpt), [
        'I learned about Jev today.',
        'It could help organise my notes.',
        'I had a lovely evening with Sarah,',
        'and I thought of a meal-planning app.',
        'Remind me to buy groceries tomorrow at 2pm.',
        'Actually, make that 3pm.',
      ]);
      // Simulated Jev boundary answers: split before U003, U004, U005.
      final yes = {2, 3, 4};
      thoughts = assembleThoughts(example, units, {
        for (var i = 1; i < units.length; i++)
          i: BoundaryDecision(yes.contains(i), false, yes.contains(i) ? 0.9 : 0.1),
      });
      plan = planClassification(example, thoughts, groups);
      final answers = decodeResponse({
        'answers': {
          ..._thought('T1', 'Tech', task: 0.05),
          ..._thought('T2', 'Personal', task: 0.02),
          ..._thought('T3', 'Ideas'),
          ..._thought('T4', 'Personal', task: 0.95, alert: 0.97),
          'T1_day': choice('none'),
          'T4_day': choice('T4D1'),
          'T4_time': choice('T4H2'),
        },
      }, plan.questions);
      final decisions = decodeClassification(plan, thoughts, answers.answers);
      var n = 0;
      items = buildProposal(
        thoughts: thoughts,
        decisions: decisions,
        plan: plan,
        groups: groups,
        capturedAtUtc: DateTime.utc(2026, 9, 17, 19, 9),
        location: tz.getLocation('Europe/London'),
        newId: () => 'item-${++n}',
      );
    });

    test('four items in three groups with one corrected reminder', () {
      expect(items.map((i) => i.groupId), ['g-tech', 'g-personal', 'g-ideas', 'g-personal']);
      expect(items.map((i) => i.kind), [
        ItemKind.note,
        ItemKind.note,
        ItemKind.note,
        ItemKind.task,
      ]);
      final task = items.last;
      expect(task.title, 'Buy groceries');
      expect(task.reminder, const DueDate(2026, 9, 18, hour: 15, minute: 0));
      expect(task.flags, isEmpty);
      expect(proposalSummary(items), '3 notes · 1 task · 1 reminder');
    });

    test('bodies copy the source; archived groups are not offered', () {
      expect(items[0].body, 'I learned about Jev today. It could help organise my notes.');
      expect(items[2].body, 'I thought of a meal-planning app.');
      expect(items[2].sources.single.excerpt, 'and I thought of a meal-planning app.');
      final groupQ = plan.questions['T1_group']! as ChoiceQuestion;
      expect(groupQ.options.keys, ['Tech', 'Personal', 'Ideas', 'Unsorted']);
      expect(groupQ.instructions, contains('thought T1'));
      expect(coverageProblems(example, items.expand((i) => i.sources)), isEmpty);
    });

    test('split and merge preserve source links and flag new pieces', () {
      final first = items.first;
      final at = example.indexOf('It could');
      final (left, right) = splitItem(first, example, at, 'item-new')!;
      expect(left.sources.single.excerpt, 'I learned about Jev today.');
      expect(right.sources.single.excerpt, 'It could help organise my notes.');
      expect(right.id, 'item-new');
      expect(right.flags, contains(ReviewFlag.newPiece));
      final merged = mergeItems(left, right);
      expect(merged.sources.map((s) => s.excerpt).join(' '), first.body);
      expect(splitItem(first, example, 0, 'x'), isNull);
    });
  });

  test('negated, historical and recall thoughts do not become tasks', () {
    const text =
        "Don't remind me to call James. I bought groceries yesterday. "
        'What did I say yesterday?';
    final units = splitCandidates(text);
    final thoughts = assembleThoughts(text, units, {
      for (var i = 1; i < units.length; i++) i: const BoundaryDecision(true, false, 0.9),
    });
    final plan = planClassification(text, thoughts, groups);
    final answers = decodeResponse({
      'answers': {
        ..._thought('T1', 'Personal', task: 0.4),
        ..._thought('T2', 'Personal', task: 0.02),
        ..._thought('T3', 'Unsorted', task: 0.05, recall: 0.95),
        'T2_day': choice('T2D1'),
        'T3_day': choice('none'),
      },
    }, plan.questions);
    final items = buildProposal(
      thoughts: thoughts,
      decisions: decodeClassification(plan, thoughts, answers.answers),
      plan: plan,
      groups: groups,
      capturedAtUtc: DateTime.utc(2026, 9, 17, 19, 9),
      location: tz.getLocation('Europe/London'),
      newId: () => 'id',
    );
    expect(items.every((i) => i.kind == ItemKind.note), isTrue);
    expect(items.every((i) => i.reminder == null), isTrue);
    expect(items[0].flags, contains(ReviewFlag.checkTask));
    expect(items[2].included, isFalse);
    expect(items[2].flags, contains(ReviewFlag.recallUnsupported));
  });

  test('titles are extractive and short', () {
    expect(
      proposedTitle(
        'Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
        remove: const [(27, 35), (39, 42), (64, 67)],
      ),
      'Buy groceries',
    );
    expect(proposedTitle('and also I thought of an app'), 'I thought of an app');
    expect(proposedTitle('x ' * 80).length, lessThanOrEqualTo(61));
    expect(proposedBody('and book a haircut'), 'Book a haircut');
  });

  test('approval problems block unresolved AM/PM and missing groups', () {
    const item = ProposalItem(
      id: 'i',
      sources: [SourceSpan(0, 1, 'x')],
      kind: ItemKind.task,
      groupId: null,
      title: 'Call mum',
      body: 'x',
      flags: {ReviewFlag.chooseAmPm},
    );
    expect(approvalProblems([item]), hasLength(2));
    final fixed = setReminder(
      setGroup(item, 'g-personal'),
      const DueDate(2026, 9, 18, hour: 14, minute: 0),
    );
    expect(approvalProblems([fixed]), isEmpty);
    expect(fixed.edited, containsAll(['group', 'reminder']));
    expect(approvalProblems([setIncluded(item, false)]), isEmpty);
  });
}

Map<String, Object?> _thought(
  String id,
  String group, {
  double task = 0.1,
  double alert = 0.05,
  double recall = 0.02,
}) => {
  '${id}_group': choice(group),
  '${id}_task': noul(task),
  '${id}_alert': noul(alert),
  '${id}_recall': noul(recall),
};
