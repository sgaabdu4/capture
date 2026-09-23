// Opt-in live end-to-end run: shortcut → record → local Parakeet transcript
// → live Jev sorting → review card, nothing in Notion yet → Yes, save →
// Notion (capture, items, audio) → reminder, then a re-save with lost local progress that must find the same
// Notion pages instead of creating new ones. Skipped unless E2E_LIVE=1.
//
//   E2E_LIVE=1 TYPESAFE_API_KEY=… NOTION_TOKEN=… NOTION_PAGE=<test page link> \
//     flutter test test/live/capture_e2e_test.dart
//
// Uses your own keys and only the dedicated test page in NOTION_PAGE; each
// run adds one capture (a dentist task and a garden idea) with its items and
// audio there. The speech is
// synthetic (macOS `say`), and the microphone, overlay and notification
// centre are stand-ins: the recorder writes that speech and reminders are
// recorded instead of shown. PARAKEET_DIR defaults to the app's downloaded
// model.
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/notion_capture_remote_datasource.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/entities/save_progress.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/repositories/capture_save_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/timezone.dart' as tz;

import '../helpers/app_harness.dart';
import '../helpers/test_fakes.dart';

final _env = Platform.environment;
final _live = _env['E2E_LIVE'] == '1';

const _task = 'Remind me tomorrow at 9 am to call the dentist.';
const _idea = 'Also, an idea for the garden: plant tomatoes along the south fence.';
const _speech = '$_task $_idea';

/// Where the app keeps the downloaded model, under the home folder.
const _appModel =
    'Library/Containers/com.afenso.capture/Data/Library/Application Support/com.afenso.capture/models/parakeet-tdt-0.6b-v3-int8';

/// The sherpa-onnx C library inside the sherpa_onnx_macos package.
const _sherpaLibrary =
    'macos/sherpa_onnx_macos/sherpa-onnx.xcframework/macos-arm64_x86_64/libsherpa-onnx-c-api.dylib';

/// The spoken fixture as a WAV file and its raw PCM16 samples.
typedef _Speech = ({File wav, List<int> pcm});

/// A WAV chunk header: four-letter id and a 32-bit size.
const _chunkHeader = 8;

/// Longest a live step may take before the run gives up.
const _stepLimit = Duration(minutes: 3);
const _poll = Duration(milliseconds: 200);

/// PCM16 mono at 16 kHz: two bytes per sample.
const _pcmBytesPerSecond = 32000;

/// Reminders the flow asked macOS to show.
class _Reminders implements IReminderDatasource {
  final titles = <String>[];

  @override
  Future<bool> schedule({
    required String itemId,
    required String title,
    required tz.TZDateTime at,
  }) async {
    titles.add(title);
    return true;
  }

  @override
  Future<void> cancel(String itemId) async {}

  @override
  Future<void> cancelAll() async {}
  @override
  Future<void> show({required String id, required String title, required String body}) async {}
}

String _required(String name) => switch (_env[name]) {
  final String value when value.isNotEmpty => value,
  _ => fail('Set $name for E2E_LIVE=1.'),
};

/// sherpa-onnx finds its C library in the app bundle; under `flutter test`
/// it has to be loaded from the plugin package first.
void _loadSherpa() {
  final config = File('.dart_tool/package_config.json').readAsStringSync();
  final packages = switch (jsonDecode(config)) {
    {'packages': final List<Object?> list} => list,
    _ => const <Object?>[],
  };
  for (final package in packages) {
    if (package case {'name': 'sherpa_onnx_macos', 'rootUri': final String root}) {
      DynamicLibrary.open(Uri.parse('$root/').resolve(_sherpaLibrary).toFilePath());
    }
  }
}

/// [_speech] spoken by `say` as a 16 kHz mono WAV file.
Future<_Speech> _synthesize(Directory dir) async {
  final wav = File('${dir.path}/speech.wav');
  final said = await Process.run('say', [
    '-o',
    wav.path,
    '--file-format=WAVE',
    '--data-format=LEI16@16000',
    _speech,
  ]);
  if (said.exitCode != 0) fail('say failed: ${said.stderr}');
  final bytes = wav.readAsBytesSync();
  final data = latin1.decode(bytes).indexOf('data');
  return (wav: wav, pcm: bytes.sublist(data + _chunkHeader));
}

/// The native side as the app sees it: the recorder writes [pcm], the
/// encoder is macOS `afconvert`, and [events] carries the shortcut.
INativePlatformService _native(StreamController<NativeEvent> events, _Speech speech) {
  final native = stubNative();
  final (:wav, :pcm) = speech;
  String? recording;
  when(() => native.events).thenAnswer((_) => events.stream);
  when(native.micPermission).thenAnswer((_) async => MicPermission.granted);
  when(() => native.startRecording(any(), limit: any(named: 'limit'))).thenAnswer((call) async {
    if (call.positionalArguments.whereType<String>().firstOrNull case final String path) {
      File(path).writeAsBytesSync(pcm);
      recording = path;
    }
  });
  when(native.stopRecording).thenAnswer(
    (_) async => (
      path: recording ?? '',
      duration: Duration(
        milliseconds: pcm.length * Duration.millisecondsPerSecond ~/ _pcmBytesPerSecond,
      ),
    ),
  );
  when(
    () => native.encodeM4a(
      input: any(named: 'input'),
      output: any(named: 'output'),
    ),
  ).thenAnswer((call) async {
    final Object? requested = call.namedArguments[#output];
    if (requested case final String output) {
      await Process.run('afconvert', ['-f', 'm4af', '-d', 'aac', wav.path, output]);
      return File(output).lengthSync();
    }
    return 0;
  });
  when(native.showMainWindow).thenAnswer((_) async {});
  return native;
}

/// The real app wiring on a fresh store under [support], with live Jev and
/// Notion and the stand-ins above.
ProviderContainer _container(
  Directory support, {
  INativePlatformService? native,
  IReminderDatasource? reminders,
}) {
  final home = _env['HOME'] ?? '';
  final container = ProviderContainer.test(
    overrides: [
      appDirectoriesProvider.overrideWithValue((
        captures: '${support.path}/captures',
        model: _env['PARAKEET_DIR'] ?? '$home/$_appModel',
        database: '${support.path}/capture.sqlite',
      )),
      secretsLocalDatasourceProvider.overrideWithValue(
        FakeSecrets({.typesafeKey: _required('TYPESAFE_API_KEY')}),
      ),
      nativePlatformServiceProvider.overrideWithValue(native ?? stubNative()),
      if (reminders != null) reminderDatasourceProvider.overrideWithValue(reminders),
    ],
  );
  return container;
}

Future<void> _connect(ProviderContainer container) async {
  final settings = container.read(settingsProvider.notifier);
  await settings.load();
  await settings.connectNotion(
    token: _required('NOTION_TOKEN'),
    pageLink: _required('NOTION_PAGE'),
  );
  final state = container.read(settingsProvider);
  expect(state.notionFailure, isNull);
  expect(state.ready, isTrue, reason: 'TypeSafe key, Notion and the Parakeet model are all set');
}

/// Waits until [done] holds for the capture flow, or fails after [_stepLimit].
Future<void> _until(ProviderContainer container, bool Function(CaptureRecord?) done) async {
  final deadline = DateTime.now().add(_stepLimit);
  while (!done(container.read(captureFlowProvider).captures.firstOrNull)) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out; last state: ${container.read(captureFlowProvider)}');
    }
    await Future<void>.delayed(_poll);
  }
}

NotionWorkspace _workspace(ProviderContainer container) =>
    switch (container.read(settingsProvider).workspace) {
      final NotionWorkspace ws => ws,
      null => fail('Notion is not connected.'),
    };

void main() {
  late Directory support;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    if (_live) _loadSherpa();
  });
  setUp(() => support = .systemTemp.createTempSync('capture_e2e'));
  tearDown(() => support.deleteSync(recursive: true));

  test(
    'a spoken capture waits for Yes, then reaches Notion with its audio and reminder, and a re-save duplicates nothing',
    () async {
      final events = StreamController<NativeEvent>();
      addTearDown(events.close);
      final reminders = _Reminders();
      final speech = await _synthesize(support);
      final container = _container(support, native: _native(events, speech), reminders: reminders);
      await _connect(container);
      // Builds the flow so it listens for the shortcut.
      container.read(captureFlowProvider);

      events.add(const HotkeyPressed());
      await _until(container, (_) => container.read(captureFlowProvider).phase == .recording);
      events.add(const HotkeyPressed());
      await _until(container, (r) => r?.stage == .proposed || r?.failure != null);
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.review));
      expect(
        container.read(captureFlowProvider).captures.firstOrNull?.progress.capturePageId,
        isNull,
      );

      events.add(const ReviewCardAction(.yes));
      await _until(container, (r) => r?.stage == .saved || r?.failure != null);

      final saved = switch (container.read(captureFlowProvider).captures.firstOrNull) {
        final CaptureRecord r => r,
        null => fail('The capture was not kept.'),
      };
      expect(saved.failure, isNull);
      expect(saved.stage, equals(CaptureStage.saved));
      expect(container.read(captureFlowProvider).phase, equals(CapturePhase.idle));
      expect(saved.transcript?.toLowerCase(), allOf(contains('dentist'), contains('tomato')));
      final SaveProgress(:capturePageId, :itemPages, :audioAttached, :markedSaved) = saved.progress;
      expect(capturePageId, isNotNull);
      expect(itemPages.keys, unorderedEquals([for (final i in saved.includedItems) i.id]));
      expect(audioAttached, isTrue);
      expect(markedSaved, isTrue);
      expect(reminders.titles.join(' ').toLowerCase(), contains('dentist'));

      final ws = _workspace(container);
      final found = await container
          .read(notionCaptureRemoteDatasourceProvider)
          .findCapturePage(ws, saved.id.value);
      expect(switch (found) {
        Ok(:final value) => value,
        Err() => null,
      }, equals(capturePageId));

      final again = await container
          .read(captureSaveRepositoryProvider)
          .save(saved.copyWith(stage: .approved, progress: const .new()), ws);
      final resaved = switch (again) {
        Ok(:final value) => value.progress,
        Err(:final failure) => fail('Re-save failed: $failure'),
      };
      expect(resaved.capturePageId, equals(capturePageId));
      expect(resaved.itemPages, equals(itemPages));
      expect(resaved.audioAttached, isTrue);
    },
    skip: _live ? false : 'Set E2E_LIVE=1 with your keys to run live.',
    timeout: .none,
  );

  test(
    'connecting from a fresh Mac finds the Notion setup instead of creating another',
    () async {
      final first = _container(support);
      await _connect(first);
      final fresh = Directory.systemTemp.createTempSync('capture_e2e_fresh');
      addTearDown(() => fresh.deleteSync(recursive: true));
      final second = _container(fresh);
      await _connect(second);

      expect(_workspace(second), equals(_workspace(first)));
    },
    skip: _live ? false : 'Set E2E_LIVE=1 with your keys to run live.',
    timeout: .none,
  );
}
