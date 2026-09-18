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

  @override
  Future<CaptureOutcome> save(CaptureRecord record, NotionWorkspace ws) async => .ok(record);

  @override
  Future<ReminderOutcome> scheduleReminders(CaptureRecord record) async =>
      (record: record, notificationsOff: !await prompt.future);
}

class _MockLibrary extends Mock implements ILibraryRepository {}

void main() {
  setUpAll(() => registerFallbackValue(_workspace));

  test('a save ends as Saved while the reminder permission prompt is unanswered', () async {
    final support = Directory.systemTemp.createTempSync('capture_flow_test');
    addTearDown(() => support.deleteSync(recursive: true));
    final saver = _Saver();
    final library = _MockLibrary();
    when(library.cached).thenReturn([]);
    when(() => library.refresh(any())).thenAnswer((_) async => const .ok([]));
    final container = ProviderContainer.test(
      overrides: [
        ...appOverrides(support: support, native: stubNative()),
        settingsProvider.overrideWith(_Connected.new),
        captureSaveRepositoryProvider.overrideWithValue(saver),
        libraryRepositoryProvider.overrideWithValue(library),
      ],
    );
    container
        .read(captureRepositoryProvider)
        .put(
          .new(
            id: 'c1',
            capturedAtUtc: FakeSystem.now,
            timeZone: FakeSystem.zone,
            audioPath: '${support.path}/c1.m4a',
            stage: .approved,
          ),
        );

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
}
