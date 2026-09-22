import 'dart:async';
import 'dart:io';

import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/transcription_datasource.dart';
import 'package:capture/features/capture/domain/capture_limits.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
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

/// Connected, with auto-save turned on.
class _AutoSave extends _Connected {
  @override
  SettingsState build() => super.build().copyWith(autoSave: true);
}

/// Key, Notion and speech model all in place, so a capture can start.
class _Ready extends SettingsNotifier {
  @override
  SettingsState build() => super.build().copyWith(
    workspace: _workspace,
    hasNotionToken: true,
    hasTypesafeKey: true,
    modelReady: true,
  );
}

/// Notion confirms every step at once; reminders wait on [prompt], like an
/// unanswered macOS notification prompt.
class _Saver implements ICaptureSaveRepository {
  _Saver({this.failure});

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
    reminded.add(record.id);
    return (record: record, notificationsOff: !await prompt.future);
  }
}

class _MockLibrary extends Mock implements ILibraryRepository {}

/// The real flow and on-disk store, connected to Notion, with [saver]; with
/// [native] as the Mac side and every setup step done when it is given.
ProviderContainer _container(
  _Saver saver, {
  INativePlatformService? native,
  SettingsNotifier Function()? settings,
  ITranscriptionDatasource? transcription,
}) {
  final support = Directory.systemTemp.createTempSync('capture_flow_test');
  addTearDown(() => support.deleteSync(recursive: true));
  final library = _MockLibrary();
  when(library.cached).thenReturn([]);
  when(() => library.refresh(any())).thenAnswer((_) async => const .ok([]));
  return .test(
    overrides: [
      ...appOverrides(support: support, native: native ?? stubNative()),
      settingsProvider.overrideWith(settings ?? (native == null ? _Connected.new : _Ready.new)),
      captureSaveRepositoryProvider.overrideWithValue(saver),
      libraryRepositoryProvider.overrideWithValue(library),
      if (transcription != null) transcriptionDatasourceProvider.overrideWithValue(transcription),
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

/// Answers with [result] whenever the test completes it.
class _Transcription implements ITranscriptionDatasource {
  const _Transcription(this.result);
  final Future<String> result;

  @override
  Future<String> transcribe(String pcmPath) => result;
}

/// A proposal with one note, ready to save unless [groupId] or [failure] say otherwise.
CaptureRecord _proposal(String id, {String? groupId = 'g', CaptureFailure? failure}) =>
    _record(id, .proposed).copyWith(
      failure: failure,
      items: [
        .new(
          id: '$id-note',
          sources: const [],
          kind: .note,
          groupId: groupId,
          title: 'Idea',
          body: '',
        ),
      ],
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_workspace);
    registerFallbackValue(Duration.zero);
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

  group('with auto-save on', () {
    test('a proposal with nothing to decide is saved without the review card', () async {
      final saver = _Saver()..prompt.complete(true);
      final container = _container(saver, settings: _AutoSave.new);
      container.read(captureRepositoryProvider).put(_proposal('c1'));

      await container.read(captureFlowProvider.notifier).process('c1');

      final flow = container.read(captureFlowProvider);
      expect(flow.phase, equals(CapturePhase.idle));
      expect(flow.autoSavedId, equals('c1'));
      expect(
        container.read(captureRepositoryProvider).get('c1')?.stage,
        equals(CaptureStage.saved),
      );
    });

    final needsLook = {
      'an item has no group': _proposal('c1', groupId: null),
      'Jev failed and it became one note': _proposal('c1', failure: .jevUnavailable),
      'nothing was heard': _record('c1', .proposed),
    };
    for (final MapEntry(key: reason, value: record) in needsLook.entries) {
      test('the review card still opens when $reason', () async {
        final container = _container(.new(), settings: _AutoSave.new);
        container.read(captureRepositoryProvider).put(record);

        await container.read(captureFlowProvider.notifier).process('c1');

        final flow = container.read(captureFlowProvider);
        expect(flow.phase, equals(CapturePhase.review));
        expect(flow.autoSavedId, isNull);
        expect(
          container.read(captureRepositoryProvider).get('c1')?.stage,
          equals(CaptureStage.proposed),
        );
      });
    }

    test('a failed save reopens the review card to retry', () async {
      final container = _container(.new(failure: .notionUnavailable), settings: _AutoSave.new);
      container.read(captureRepositoryProvider).put(_proposal('c1'));

      await container.read(captureFlowProvider.notifier).process('c1');

      final flow = container.read(captureFlowProvider);
      expect(flow.phase, equals(CapturePhase.review));
      expect(flow.failure, equals(CaptureFailure.notionUnavailable));
      expect(flow.autoSavedId, isNull);
    });
  });

  test('with auto-save off, a proposal with nothing to decide waits on the review card', () async {
    final container = _container(.new());
    container.read(captureRepositoryProvider).put(_proposal('c1'));

    await container.read(captureFlowProvider.notifier).process('c1');

    expect(container.read(captureFlowProvider).phase, equals(CapturePhase.review));
    expect(
      container.read(captureRepositoryProvider).get('c1')?.stage,
      equals(CaptureStage.proposed),
    );
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

  test('a recording crashed mid-way keeps its length from the audio on disk; a tap is dropped', () {
    final container = _container(.new());
    final audio = Directory.systemTemp.createTempSync('capture_flow_audio');
    addTearDown(() => audio.deleteSync(recursive: true));
    // PCM16 mono at 16 kHz: 32000 bytes a second.
    final twoSeconds = File('${audio.path}/c1.pcm')..writeAsBytesSync(.filled(64000, 0));
    final accidental = File('${audio.path}/c2.pcm')..writeAsBytesSync(.filled(3200, 0));
    final captures = container.read(captureRepositoryProvider)
      ..put(_record('c1', .recorded).copyWith(audioPath: twoSeconds.path))
      ..put(_record('c2', .recorded).copyWith(audioPath: accidental.path));

    container.read(captureFlowProvider.notifier).recoverInterrupted();

    expect(captures.get('c1')?.duration, equals(const Duration(seconds: 2)));
    expect(captures.get('c2'), isNull);
  });

  test('a recording is capped at five minutes and stops when the recorder hits it', () async {
    final events = StreamController<NativeEvent>();
    addTearDown(events.close);
    final native = stubNative();
    when(() => native.events).thenAnswer((_) => events.stream);
    when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
    when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((_) async {});
    when(native.stopRecording).thenAnswer((_) async => null);
    final container = _container(.new(), native: native);
    final flow = container.read(captureFlowProvider.notifier);

    await flow.start();
    expect(container.read(captureFlowProvider).phase, equals(CapturePhase.recording));
    events.add(const LimitReached());
    await pumpEventQueue();

    verify(() => native.startRecording(any(), limit: maxCaptureDuration)).called(1);
    verify(native.stopRecording).called(1);
    expect(container.read(captureFlowProvider).phase, equals(CapturePhase.idle));
    expect(container.read(captureFlowProvider).notice, equals(CaptureNotice.limitReached));
  });

  group('Record with Capture', () {
    late StreamController<NativeEvent> events;
    late INativePlatformService native;

    setUp(() {
      events = .broadcast();
      addTearDown(events.close);
      native = stubNative();
      when(() => native.events).thenAnswer((_) => events.stream);
      when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
      when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((_) async {});
      when(native.takeRecordRequest).thenAnswer((_) async => true);
    });

    test('a request while idle starts recording', () async {
      final container = _container(.new(), native: native);
      container.read(captureFlowProvider);

      events.add(const RecordRequested());
      await pumpEventQueue();

      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.recording));
    });

    test('a second request, or one arriving mid-start, keeps a single recording', () async {
      final container = _container(.new(), native: native);
      container.read(captureFlowProvider);

      // The second arrives while the first is still asking for the microphone.
      for (final _ in [1, 2]) {
        events.add(const RecordRequested());
      }
      await pumpEventQueue();
      events.add(const RecordRequested());
      await pumpEventQueue();

      verify(() => native.startRecording(any(), limit: any(named: 'limit'))).called(1);
      expect(container.read(captureRepositoryProvider).all(), hasLength(1));
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.recording));
    });

    test('a request that launched the app starts recording once it is taken', () async {
      final container = _container(.new(), native: native);

      await container.read(captureFlowProvider.notifier).takePendingRequest();

      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.recording));
    });

    test('a normal launch, with no request waiting, stays idle', () async {
      when(native.takeRecordRequest).thenAnswer((_) async => false);
      final container = _container(.new(), native: native);

      await container.read(captureFlowProvider.notifier).takePendingRequest();

      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.idle));
      verifyNever(() => native.startRecording(any(), limit: any(named: 'limit')));
    });

    test('a request while the review card is open leaves it open', () async {
      final container = _container(.new(), native: native);
      container.read(captureRepositoryProvider).put(_proposal('c1'));
      await container.read(captureFlowProvider.notifier).process('c1');

      events.add(const RecordRequested());
      await pumpEventQueue();

      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.review));
      verifyNever(() => native.startRecording(any(), limit: any(named: 'limit')));
    });
  });

  test('an interruption during Stop leaves the capture being transcribed', () async {
    final events = StreamController<NativeEvent>.broadcast();
    addTearDown(events.close);
    final native = stubNative();
    when(() => native.events).thenAnswer((_) => events.stream);
    when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
    when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((_) async {});
    // The first stop answers once the recorder has finished; a later stop
    // finds nothing to stop.
    final firstStop = Completer<RecordingResult?>();
    final stops = [firstStop.future];
    when(native.stopRecording).thenAnswer((_) => stops.isEmpty ? .value(null) : stops.removeLast());
    final transcript = Completer<String>();
    final container = _container(
      .new(),
      native: native,
      transcription: _Transcription(transcript.future),
    );
    final flow = container.read(captureFlowProvider.notifier);
    await flow.start();

    final stopping = flow.stop();
    events.add(const RecordingFailed());
    await pumpEventQueue();
    firstStop.complete((path: 'c.pcm', duration: const Duration(seconds: 3)));
    await pumpEventQueue();

    expect(container.read(captureFlowProvider).phase, equals(CapturePhase.transcribing));
    transcript.completeError(Exception('done'), .current);
    await stopping;
  });

  test('an interruption stops the recording and transcribes the audio kept', () async {
    final events = StreamController<NativeEvent>.broadcast();
    addTearDown(events.close);
    final native = stubNative();
    when(() => native.events).thenAnswer((_) => events.stream);
    when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
    when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((_) async {});
    when(native.stopRecording)
        .thenAnswer((_) async => (path: 'c.pcm', duration: const Duration(seconds: 3)));
    final transcript = Completer<String>();
    final container = _container(
      .new(),
      native: native,
      transcription: _Transcription(transcript.future),
    );
    await container.read(captureFlowProvider.notifier).start();

    events.add(const RecordingFailed());
    await pumpEventQueue();

    final flow = container.read(captureFlowProvider);
    expect(flow.phase, equals(CapturePhase.transcribing));
    expect(flow.notice, equals(CaptureNotice.recordingInterrupted));
    expect(flow.active?.duration, equals(const Duration(seconds: 3)));
    transcript.completeError(Exception('done'), .current);
  });

  test('without microphone access nothing records and the notice says why', () async {
    final native = stubNative();
    when(native.micPermission).thenAnswer((_) async => MicPermission.denied);
    when(native.showMainWindow).thenAnswer((_) async {});
    final container = _container(.new(), native: native);

    await container.read(captureFlowProvider.notifier).start();

    expect(container.read(captureFlowProvider).notice, equals(CaptureNotice.micDenied));
    expect(container.read(captureRepositoryProvider).all(), isEmpty);
    verifyNever(() => native.startRecording(any(), limit: any(named: 'limit')));
  });

  test('Retry transcribes a capture recorded before setup once setup is done', () async {
    final transcript = Completer<String>();
    final container = _container(
      .new(),
      native: stubNative(),
      transcription: _Transcription(transcript.future),
    );
    container.read(captureRepositoryProvider).put(_record('c1', .recorded));
    final flow = container.read(captureFlowProvider.notifier);

    final retrying = flow.process('c1');
    await pumpEventQueue();

    expect(container.read(captureFlowProvider).phase, equals(CapturePhase.transcribing));
    transcript.completeError(Exception('done'), .current);
    await retrying;
  });

  test('before setup a capture records and stays recorded with a notice', () async {
    final native = stubNative();
    when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
    when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((_) async {});
    when(native.stopRecording)
        .thenAnswer((_) async => (path: 'c.pcm', duration: const Duration(seconds: 3)));
    final container = _container(.new(), native: native, settings: _Connected.new);
    final flow = container.read(captureFlowProvider.notifier);

    await flow.start();
    await flow.stop();

    final captures = container.read(captureRepositoryProvider);
    expect(captures.all().map((r) => r.stage), equals([CaptureStage.recorded]));
    expect(container.read(captureFlowProvider).notice, equals(CaptureNotice.setupIncomplete));
  });
}
