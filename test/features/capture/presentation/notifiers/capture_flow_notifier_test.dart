import 'dart:async';
import 'dart:io';

import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/capture/repositories/capture_save_repository.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

/// The real flow and on-disk store, connected to Notion, with [saver].
ProviderContainer _container(_Saver saver) {
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

void main() {
  setUpAll(() => registerFallbackValue(_workspace));

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
}
