import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/edited_field.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/jev/boundary_pass.dart';
import 'package:capture/features/capture/domain/jev/classification_pass.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/proposal/edits.dart';
import 'package:capture/features/capture/domain/proposal/proposal_builder.dart';
import 'package:capture/features/capture/domain/proposal/proposal_counts.dart';
import 'package:capture/features/capture/domain/text/assembly.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/domain/text/titles.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const _example =
    'I learned about Jev today. It could help organise my notes. I had a lovely evening with Sarah, and I thought of a meal-planning app. Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.';

const _groups = [
  Group(id: 'g-tech', name: 'Tech', description: 'Programming and AI'),
  Group(id: 'g-personal', name: 'Personal', description: 'Daily life'),
  Group(id: 'g-ideas', name: 'Ideas', description: 'Possible products'),
  Group(id: 'g-old', name: 'Old', description: 'Archived', archived: true),
  Group(id: 'g-unsorted', name: 'Unsorted', description: 'None fits'),
];

/// The plan and the proposal built from it.
typedef _Proposal = ({ClassificationPlan plan, List<ProposalItem> items});

/// A malformed answer set and the failure it must produce.
typedef _BadAnswers = ({Map<String, Object?> answers, JevProtocolFailure failure});

Map<String, Object?> _choice(String c, [double p = 0.9]) => {
  'type': 'choice',
  'choice': c,
  'confidence': p,
  'probabilities': {c: 0.9},
};

Map<String, Object?> _noul(double p) => {'type': 'noul', 'noul': p};

Map<String, Object?> _thought(String id, String group, {double task = 0.1, double alert = 0.05}) =>
    {
      '${id}_group': _choice(group),
      '${id}_task': _noul(task),
      '${id}_alert': _noul(alert),
      '${id}_recall': _noul(0.02),
    };

/// The success value of [result]; fails the test on an error.
T _ok<T>(Result<T, JevProtocolFailure> result) => switch (result) {
  Ok(:final value) => value,
  Err(:final failure) => fail('unexpected $failure'),
};

/// The failure of [result], or null on success.
JevProtocolFailure? _failure<T>(Result<T, JevProtocolFailure> result) => switch (result) {
  Ok() => null,
  Err(:final failure) => failure,
};

/// Thu 17 Sep 2026 20:09 in London.
CaptureMoment _moment() => .new(
  capturedAtUtc: .utc(2026, 9, 17, 19, 9),
  offsetAt: (utc) => tz.getLocation('Europe/London').timeZone(utc.millisecondsSinceEpoch).offset,
);

/// Proposal for [transcript] where Jev splits before every unit index in
/// [splits] and answers classification with [classification].
_Proposal _propose(String transcript, Set<int> splits, Map<String, Object?> classification) {
  final units = splitCandidates(transcript);
  final thoughts = assembleThoughts(transcript, units, {
    for (int i = 1; i < units.length; i++)
      i: .new(split: splits.contains(i), uncertain: false, yes: splits.contains(i) ? 0.9 : 0.1),
  });
  final plan = planClassification(transcript, thoughts, _groups);
  final decoded = _ok(decodeResponse({'answers': classification}, plan.questions)).answers;
  int n = 0;
  return (
    plan: plan,
    items: buildProposal(
      decisions: _ok(decodeClassification(plan, thoughts, decoded)),
      plan: plan,
      moment: _moment(),
      newId: () => 'item-${++n}',
    ),
  );
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('boundary questions name their unit in the instructions', () {
    final units = splitCandidates(_example);
    final questions = boundaryQuestions(units);
    expect(questions, hasLength(units.length - 1));
    for (final u in units.skip(1)) {
      expect(questions[boundaryKey(u)]?.instructions, contains('unit ${u.id}'));
    }
    expect(boundaryState(units), contains('U001| I learned about Jev today.'));
  });

  test('decodeResponse validates types, ranges and option membership', () {
    final asked = <String, JevQuestion>{
      'a': const .noul('Is it?'),
      'b': .choice('Which?', {'x': 'X', 'y': 'Y'}),
    };
    final JevResult(:answers, :usage) = _ok(
      decodeResponse({
        'model': 'jev-1.13.0',
        'answers': {'a': _noul(0.2), 'b': _choice('y', 0.5)},
        'usage': {'input_tokens': 10, 'output_tokens': 2},
      }, asked),
    );
    expect(answers['a'], equals(const JevAnswer.noul(0.2)));
    expect(answers['b'], isA<ChoiceAnswer>().having((a) => a.choice, 'choice', equals('y')));
    expect(usage.inputTokens, equals(10));

    final bad = <_BadAnswers>[
      (answers: {'a': _noul(0.2)}, failure: .missingAnswer),
      (answers: {'a': _noul(1.5), 'b': _choice('x')}, failure: .notAProbability),
      (answers: {'a': _noul(0.5), 'b': _choice('z')}, failure: .choiceOutsideOptions),
      (answers: {'a': _choice('x'), 'b': _choice('x')}, failure: .wrongAnswerType),
    ];
    for (final (:answers, :failure) in bad) {
      expect(_failure(decodeResponse({'answers': answers}, asked)), equals(failure));
    }
    expect(_failure(decodeResponse('nope', asked)), equals(JevProtocolFailure.notAnObject));
  });

  test('batching keeps every question and repeats full state', () {
    final questions = <String, JevQuestion>{
      for (int i = 0; i < 400; i++) 'q$i': .noul('Question $i ${'padding ' * 60}'),
    };
    final batches = _ok(batchQuestions('state', questions));
    expect(batches.length, greaterThan(1));
    expect(batches.expand((b) => b.keys).toSet(), equals(questions.keys.toSet()));
    expect(
      _failure(batchQuestions('x' * 80000, {'a': const .noul('q')})),
      equals(JevProtocolFailure.transcriptTooLong),
    );
  });

  test('assembly accounts for every source passage exactly once', () {
    final units = splitCandidates(_example);
    final thoughts = assembleThoughts(_example, units, {
      for (int i = 1; i < units.length; i++)
        i: .new(split: i.isEven, uncertain: i == 3, yes: i.isEven ? 0.8 : 0.2),
    });
    final inside = thoughts.expand((t) => t.units).map((u) => u.span);
    expect(coverageProblems(_example, inside), isEmpty);
    expect(coverageProblems(_example, thoughts.map((t) => t.span)), isEmpty);
    expect(thoughts.firstOrNull?.span.excerpt, startsWith('I learned about Jev today. It'));
    expect(thoughts.any((t) => t.uncertainStart), isTrue);
  });

  test('a late correction starts its own flagged item', () {
    const text = 'Remind me to call mum at 5pm. Buy stamps. Oh, and make the call at 6pm instead.';
    final units = splitCandidates(text);
    expect(units, hasLength(3));
    expect(lateCorrectionQuestions(units).keys, equals(['late_U003']));
    final thoughts = assembleThoughts(text, units, {
      1: const .new(split: true, uncertain: false, yes: 0.9),
      2: const .new(split: false, uncertain: false, yes: 0.1, lateCorrection: true),
    });
    expect(thoughts, hasLength(3));
    expect(thoughts.last.lateCorrection, isTrue);
    expect(thoughts.last.span.excerpt, startsWith('Oh, and make the call'));
  });

  test('the brief example splits into the expected candidate units', () {
    expect(
      splitCandidates(_example).map((u) => u.span.excerpt),
      equals([
        'I learned about Jev today.',
        'It could help organise my notes.',
        'I had a lovely evening with Sarah,',
        'and I thought of a meal-planning app.',
        'Remind me to buy groceries tomorrow at 2pm.',
        'Actually, make that 3pm.',
      ]),
    );
  });

  group('the brief example', () {
    late ClassificationPlan plan;
    late List<ProposalItem> items;

    setUp(() {
      // Simulated Jev boundary answers: split before U003, U004, U005.
      (:plan, :items) = _propose(
        _example,
        {2, 3, 4},
        {
          ..._thought('T1', 'Tech', task: 0.05),
          ..._thought('T2', 'Personal', task: 0.02),
          ..._thought('T3', 'Ideas'),
          ..._thought('T4', 'Personal', task: 0.95, alert: 0.97),
          'T1_day': _choice('none'),
          'T4_day': _choice('T4D1'),
          'T4_time': _choice('T4H2'),
        },
      );
    });

    test('four items in three groups with one corrected reminder', () {
      expect(
        items.map((i) => i.groupId),
        equals(['g-tech', 'g-personal', 'g-ideas', 'g-personal']),
      );
      expect(
        items.map((i) => i.kind),
        equals([ItemKind.note, ItemKind.note, ItemKind.note, ItemKind.task]),
      );
      final ProposalItem(:title, :reminder, :flags) = items.last;
      expect(title, equals('Buy groceries'));
      expect(reminder, equals(const DueDate(2026, 9, 18, hour: 15, minute: 0)));
      expect(flags, isEmpty);
      expect(countProposal(items), equals((notes: 3, tasks: 1, reminders: 1)));
    });

    test('bodies copy the source; archived groups are not offered', () {
      expect(items[0].body, equals('I learned about Jev today. It could help organise my notes.'));
      expect(items[2].body, equals('I thought of a meal-planning app.'));
      expect(
        items[2].sources.map((s) => s.excerpt),
        equals(['and I thought of a meal-planning app.']),
      );
      expect(
        plan.questions['T1_group'],
        isA<ChoiceQuestion>()
            .having(
              (q) => q.options.keys,
              'options',
              equals(['Tech', 'Personal', 'Ideas', 'Unsorted']),
            )
            .having((q) => q.instructions, 'instructions', contains('thought T1')),
      );
      expect(coverageProblems(_example, items.expand((i) => i.sources)), isEmpty);
    });

    test('split and merge preserve source links and flag new pieces', () {
      final first = items[0];
      final at = _example.indexOf('It could');
      final (:left, :right) = splitItem(first, _example, at, 'item-new') ?? fail('no split');
      expect(left.sources.map((s) => s.excerpt), equals(['I learned about Jev today.']));
      expect(right.sources.map((s) => s.excerpt), equals(['It could help organise my notes.']));
      expect(right.id, equals('item-new'));
      expect(right.flags, contains(ReviewFlag.newPiece));
      final merged = mergeItems(left, right);
      expect(merged.sources.map((s) => s.excerpt).join(' '), equals(first.body));
      expect(splitItem(first, _example, 0, 'x'), isNull);
    });
  });

  test('negated, historical and recall thoughts do not become tasks', () {
    const text =
        "Don't remind me to call James. I bought groceries yesterday. What did I say yesterday?";
    final (plan: _, :items) = _propose(
      text,
      {1, 2},
      {
        ..._thought('T1', 'Personal', task: 0.4),
        ..._thought('T2', 'Personal', task: 0.02),
        ..._thought('T3', 'Unsorted', task: 0.05),
        'T3_recall': _noul(0.95),
        'T2_day': _choice('T2D1'),
        'T3_day': _choice('none'),
      },
    );
    expect(items.every((i) => i.kind == .note), isTrue);
    expect(items.every((i) => i.reminder == null), isTrue);
    expect(items[0].flags, contains(ReviewFlag.checkTask));
    expect(items[2].included, isFalse);
    expect(items[2].flags, contains(ReviewFlag.recallUnsupported));
  });

  test('titles are extractive and short', () {
    expect(
      proposedTitle(
        'Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
        remove: const [(start: 27, end: 35), (start: 39, end: 42), (start: 64, end: 67)],
      ),
      equals('Buy groceries'),
    );
    expect(
      proposedTitle(
        'Call the dentist at 9 tomorrow to book a checkup',
        remove: const [(start: 20, end: 30)],
      ),
      equals('Call the dentist to book a checkup'),
    );
    expect(proposedTitle('and also I thought of an app'), equals('I thought of an app'));
    expect(proposedTitle('x ' * 80).length, lessThanOrEqualTo(61));
    expect(proposedBody('and book a haircut'), equals('Book a haircut'));
  });

  test('approval problems block unresolved AM/PM and missing groups', () {
    const item = ProposalItem(
      id: 'i',
      sources: [.new(0, 1, 'x')],
      kind: .task,
      groupId: null,
      title: 'Call mum',
      body: 'x',
      flags: {.chooseAmPm},
    );
    expect(item.approvalProblems, hasLength(2));
    final fixed = item
        .withGroup('g-personal')
        .withReminder(const .new(2026, 9, 18, hour: 14, minute: 0));
    expect(fixed.approvalProblems, isEmpty);
    expect(fixed.edited, containsAll([EditedField.group, EditedField.reminder]));
    expect(item.withIncluded(value: false).approvalProblems, isEmpty);
  });
}
