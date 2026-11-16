import 'dart:async';
import 'dart:io';

import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/transcription_datasource.dart';
import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
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

import 'app_harness.dart';
import 'test_fakes.dart';

final flowWorkspace = NotionWorkspace(
  parentPageId: .new('parent'),
  areaPageId: .new('area'),
  groups: .new('groups'),
  captures: .new('captures'),
  library: .new('library'),
  maxUpload: .fromBytes(1),
);

SettingsState connectedSettings(Ref ref, SettingsNotifier notifier) =>
    notifier.build().copyWith(workspace: flowWorkspace, hasNotionToken: true);

/// Connected, with auto-save turned on.
SettingsState autoSaveSettings(Ref ref, SettingsNotifier notifier) =>
    connectedSettings(ref, notifier).copyWith(autoSave: true);

/// Key, Notion and speech model all in place, so a capture can start.
SettingsState flowReadySettings(Ref ref, SettingsNotifier notifier) => notifier.build().copyWith(
  workspace: flowWorkspace,
  hasNotionToken: true,
  hasTypesafeKey: true,
  modelReady: true,
);

/// Keep reminders waiting on [prompt] to reproduce an unanswered macOS notification prompt.
class FlowSaver implements ICaptureSaveRepository {
  FlowSaver({this.failure});

  /// Notion refuses every save with this, when set.
  final CaptureFailure? failure;

  final prompt = Completer<bool>();

  /// Ids of captures whose reminders were scheduled.
  final reminded = <String>[];

  @override
  Future<CaptureOutcome> save(CaptureRecord record, NotionWorkspace ws) async => switch (failure) {
    final CaptureFailure f => .err(f),
    null => .ok(record),
  };

  @override
  Future<ReminderOutcome> scheduleReminders(CaptureRecord record) async {
    reminded.add(record.id.value);
    return (record: record, notificationsOff: !await prompt.future);
  }
}

class MockLibrary extends Mock implements ILibraryRepository {}

ProviderContainer flowContainer(
  FlowSaver? saver, {
  INativePlatformService? native,
  IReminderDatasource? reminders,
  SettingsState Function(Ref ref, SettingsNotifier notifier)? settings,
  ITranscriptionDatasource? transcription,
  ICaptureAnalysisRepository? analysis,
}) {
  final support = Directory.systemTemp.createTempSync('capture_flow_test');
  addTearDown(() => support.deleteSync(recursive: true));
  final library = MockLibrary();
  when(library.cached).thenReturn([]);
  when(() => library.refresh(any())).thenAnswer((_) async => const .ok([]));
  return .test(
    overrides: [
      ...appOverrides(
        support: support,
        native: native ?? stubNative(),
        fakes: (secrets: null, reminders: reminders, system: null),
      ),
      settingsProvider.overrideWithBuild(
        settings ?? (native == null ? connectedSettings : flowReadySettings),
      ),
      if (saver != null) captureSaveRepositoryProvider.overrideWithValue(saver),
      libraryRepositoryProvider.overrideWithValue(library),
      if (transcription != null) transcriptionDatasourceProvider.overrideWithValue(transcription),
      if (analysis != null) captureAnalysisRepositoryProvider.overrideWithValue(analysis),
    ],
  );
}

CaptureRecord flowRecord(String id, CaptureStage stage) => .new(
  id: .new(id),
  capturedAtUtc: FakeSystem.now,
  timeZone: .new(FakeSystem.zone),
  audioPath: .new('$id.m4a'),
  stage: stage,
);

/// Answers every analysis with [outcome] and notes whether it was asked.
class FakeAnalysis implements ICaptureAnalysisRepository {
  FakeAnalysis(this.outcome);
  final JevOutcome<Analysis> outcome;
  bool asked = false;

  @override
  Future<JevOutcome<Analysis>> analyze({
    required String transcript,
    required List<Group> groups,
    required CaptureMoment moment,
  }) async {
    asked = true;
    return outcome;
  }
}

/// A proposal with one note, ready to save unless [groupId] or [failure] say otherwise.
CaptureRecord flowProposal(String id, {String? groupId = 'g', CaptureFailure? failure}) =>
    flowRecord(id, .proposed).copyWith(
      failure: failure,
      items: [
        .new(
          id: .new('$id-note'),
          sources: const [],
          kind: .note,
          groupId: groupId == null ? null : .new(groupId),
          title: 'Idea',
          body: '',
        ),
      ],
    );
