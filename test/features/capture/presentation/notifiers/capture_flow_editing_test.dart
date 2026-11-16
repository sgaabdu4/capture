import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../../helpers/capture_flow_harness.dart';

CaptureRecord _transcribed(String? transcript) =>
    flowRecord('c1', .transcribed).copyWith(transcript: transcript);

ProposalItem? _stored(ProviderContainer container) =>
    container.read(captureRepositoryProvider).get('c1')?.items.singleOrNull;

ProviderContainer _reviewing(ProposalItem item) {
  final container = flowContainer(.new());
  container
      .read(captureRepositoryProvider)
      .put(flowRecord('c1', .proposed).copyWith(items: [item]));
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(flowWorkspace);
    registerFallbackValue(Duration.zero);
    tzdata.initializeTimeZones();
  });

  group('analysing a transcript', () {
    final note = ProposalItem(
      id: .new('analysed'),
      sources: const [],
      kind: .note,
      groupId: .new('g'),
      title: 'Heard',
      body: '',
    );

    test('a transcript becomes the items Jev proposed', () async {
      final container = flowContainer(
        .new(),
        analysis: FakeAnalysis(
          .ok(Analysis(items: [note], thoughts: const [], units: const [], calls: const [])),
        ),
      );
      container.read(captureRepositoryProvider).put(_transcribed('Heard this.'));

      await container.read(captureFlowProvider.notifier).process('c1');

      final stored = container.read(captureRepositoryProvider).get('c1');
      expect(stored?.stage, equals(CaptureStage.proposed));
      expect(stored?.items.map((i) => i.title), equals(['Heard']));
      expect(stored?.failure, isNull);
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.review));
    });

    final failures = {
      JevFailure.invalidKey: CaptureFailure.jevKey,
      JevFailure.rateLimited: CaptureFailure.jevUnavailable,
      JevFailure.unavailable: CaptureFailure.jevUnavailable,
      JevFailure.network: CaptureFailure.jevUnavailable,
      JevFailure.invalidResponse: CaptureFailure.jevResponse,
    };
    for (final MapEntry(key: jev, value: expected) in failures.entries) {
      test(
        'a Jev failure ($jev) keeps the whole transcript as one note and records $expected',
        () async {
          final container = flowContainer(.new(), analysis: FakeAnalysis(.err(jev)));
          container.read(captureRepositoryProvider).put(_transcribed('Keep every word.'));

          await container.read(captureFlowProvider.notifier).process('c1');

          final stored = container.read(captureRepositoryProvider).get('c1');
          expect(stored?.stage, equals(CaptureStage.proposed));
          expect(stored?.failure, equals(expected));
          expect(stored?.items.map((i) => i.kind), equals([ItemKind.note]));
          expect(stored?.items.single.body, contains('Keep every word.'));
        },
      );
    }

    for (final transcript in [null, '   ']) {
      test(
        'a transcript of ${transcript ?? 'nothing'} proposes no items and asks nobody',
        () async {
          final analysis = FakeAnalysis(const Err(JevFailure.network));
          final container = flowContainer(.new(), analysis: analysis);
          container.read(captureRepositoryProvider).put(_transcribed(transcript));

          await container.read(captureFlowProvider.notifier).process('c1');

          final stored = container.read(captureRepositoryProvider).get('c1');
          expect(stored?.stage, equals(CaptureStage.proposed));
          expect(stored?.items, isEmpty);
          expect(analysis.asked, isFalse);
        },
      );
    }
  });

  group('deleting a capture', () {
    test('a saved capture is deleted', () async {
      final container = flowContainer(.new());
      final captures = container.read(captureRepositoryProvider)..put(flowRecord('c1', .saved));

      await container.read(captureFlowProvider.notifier).delete('c1');

      expect(captures.get('c1'), isNull);
    });

    test('an approved capture is kept, so a retry cannot duplicate it in Notion', () async {
      final container = flowContainer(.new());
      final captures = container.read(captureRepositoryProvider)..put(flowRecord('c1', .approved));

      await container.read(captureFlowProvider.notifier).delete('c1');

      expect(captures.get('c1'), isNotNull);
    });

    test('the capture on the review card is kept', () async {
      final container = flowContainer(.new());
      final captures = container.read(captureRepositoryProvider)..put(flowProposal('c1'));
      final flow = container.read(captureFlowProvider.notifier)..showReview('c1');

      await flow.delete('c1');

      expect(captures.get('c1'), isNotNull);
    });

    test('an unknown capture is ignored', () async {
      final container = flowContainer(.new());

      await expectLater(container.read(captureFlowProvider.notifier).delete('missing'), completes);
    });
  });

  group('the reminder of a task being reviewed', () {
    const due = DueDate(2030, 5, 1, hour: 9, minute: 30);
    final task = ProposalItem(
      id: .new('c1-task'),
      sources: const [],
      kind: .task,
      groupId: .new('g'),
      title: 'Call',
      body: '',
      due: due,
    );

    test('turning it on sets the reminder at the due date and time', () {
      final container = _reviewing(task);

      container.read(captureFlowProvider.notifier).setReminder('c1', task, on: true);

      expect(_stored(container)?.reminder, equals(due));
    });

    test('turning it off removes the reminder', () {
      final withReminder = task.withReminder(due);
      final container = _reviewing(withReminder);

      container.read(captureFlowProvider.notifier).setReminder('c1', withReminder, on: false);

      expect(_stored(container)?.reminder, isNull);
    });

    test('turning it on with no time of day changes nothing', () {
      final dateOnly = task.copyWith(due: const .new(2030, 5, 1));
      final container = _reviewing(dateOnly);

      container.read(captureFlowProvider.notifier).setReminder('c1', dateOnly, on: true);

      expect(_stored(container)?.reminder, isNull);
      expect(_stored(container)?.due, equals(dateOnly.due));
    });

    test('a capture already approved cannot be changed', () {
      final container = flowContainer(.new());
      container
          .read(captureRepositoryProvider)
          .put(flowRecord('c1', .approved).copyWith(items: [task]));

      container.read(captureFlowProvider.notifier).setReminder('c1', task, on: true);

      expect(_stored(container)?.reminder, isNull);
    });
  });
}
