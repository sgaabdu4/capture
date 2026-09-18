import 'dart:async';
import 'dart:io';

import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/repositories/capture_analysis_repository.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/capture/repositories/capture_save_repository.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/test_fakes.dart';

const _workspace = NotionWorkspace(
  parentPageId: 'parent',
  areaPageId: 'area',
  groups: 'groups',
  captures: 'captures',
  library: 'library',
  maxUploadBytes: 1,
);

class _Connected extends SettingsNotifier {
  @override
  SettingsState build() => super.build().copyWith(workspace: _workspace, hasNotionToken: true);
}

/// Notion confirms every step at once; reminders wait on [prompt], like an
/// unanswered macOS notification prompt.
class _Saver implements ICaptureSaveRepository {
  final prompt = Completer<bool>();

  /// Ids of captures whose reminders were scheduled.
  final reminded = <String>[];

  @override
  Future<CaptureOutcome> save(CaptureRecord record, NotionWorkspace ws) async => .ok(record);

  @override
  Future<ReminderOutcome> scheduleReminders(CaptureRecord record) async {
    reminded.add(record.id);
    return (record: record, notificationsOff: !await prompt.future);
  }
}

class _MockLibrary extends Mock implements ILibraryRepository {}

/// Jev sorts any transcript into one note, in group [groupId] if given.
class _SortsInto implements ICaptureAnalysisRepository {
  const _SortsInto(this.groupId);
  final String? groupId;

  @override
  Future<JevOutcome<Analysis>> analyze({
    required String transcript,
    required List<Group> groups,
    required CaptureMoment moment,
  }) async => .ok(
    .new(
      items: [
        .new(id: 'n1', sources: const [], kind: .note, groupId: groupId, title: 'Idea', body: ''),
      ],
      thoughts: const [],
      units: const [],
      calls: const [],
    ),
  );
}

/// The real flow and on-disk store, connected to Notion, with [saver] and,
/// if given, [analysis] in place of Jev.
ProviderContainer _container(_Saver saver, {ICaptureAnalysisRepository? analysis}) {
  final support = Directory.systemTemp.createTempSync('capture_flow_test');
  addTearDown(() => support.deleteSync(recursive: true));
  final library = _MockLibrary();
  when(library.cached).thenReturn([]);
  when(() => library.refresh(any())).thenAnswer((_) async => const .ok([]));
  return .test(
    overrides: [
      ...appOverrides(support: support, native: stubNative()),
      settingsProvider.overrideWith(_Connected.new),
      captureSaveRepositoryProvider.overrideWithValue(saver),
      libraryRepositoryProvider.overrideWithValue(library),
      if (analysis != null) captureAnalysisRepositoryProvider.overrideWithValue(analysis),
    ],
  );
}

CaptureRecord _record(String id, CaptureStage stage) => .new(
  id: id,
  capturedAtUtc: FakeSystem.now,
  timeZone: FakeSystem.zone,
  audioPath: '$id.m4a',
  stage: stage,
);

/// Runs a transcribed capture through sorting and returns the flow.
Future<ProviderContainer> _sortInto(String? groupId) async {
  final container = _container(_Saver()..prompt.complete(true), analysis: _SortsInto(groupId));
  container
      .read(captureRepositoryProvider)
      .put(_record('c1', .transcribed).copyWith(transcript: 'Idea for the garden'));
  await container.read(captureFlowProvider.notifier).process('c1');
  return container;
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    registerFallbackValue(_workspace);
  });

  test('a save ends as Saved while the reminder permission prompt is unanswered', () async {
    final saver = _Saver();
    final container = _container(saver);
    container.read(captureRepositoryProvider).put(_record('c1', .approved));

    final approval = container.read(captureFlowProvider.notifier).approve('c1');
    await pumpEventQueue();

    final saving = container.read(captureFlowProvider);
    expect(saving.phase, equals(CapturePhase.idle));
    expect(saving.notice, equals(CaptureNotice.saved));
    expect(container.read(captureRepositoryProvider).get('c1')?.stage, equals(CaptureStage.saved));

    saver.prompt.complete(false);
    await approval;
    expect(container.read(captureFlowProvider).notice, equals(CaptureNotice.savedNotificationsOff));
  });

  test('a reminder a saved capture still owes is scheduled on the next launch', () async {
    final saver = _Saver()..prompt.complete(true);
    final container = _container(saver);
    container.read(captureRepositoryProvider)
      ..put(_record('saved', .saved))
      ..put(_record('proposed', .proposed));

    await container.read(captureFlowProvider.notifier).resumeReminders();

    expect(saver.reminded, equals(['saved']));
  });

  group('after sorting', () {
    test('a cleanly sorted capture saves to Notion without the review card', () async {
      final container = await _sortInto('g');

      expect(
        container.read(captureRepositoryProvider).get('c1')?.stage,
        equals(CaptureStage.saved),
      );
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.idle));
    });

    test('a capture that needs a group waits on the review card', () async {
      final container = await _sortInto(null);

      expect(
        container.read(captureRepositoryProvider).get('c1')?.stage,
        equals(CaptureStage.proposed),
      );
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.review));
    });
  });
}
