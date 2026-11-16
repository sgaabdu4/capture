import 'dart:async';

import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettings extends Mock implements ISettingsRepository {}

({ProviderContainer container, StreamController<SpeechModelEvent> events, _MockSettings repo})
_downloading() {
  final repo = _MockSettings();
  when(repo.shortcut).thenReturn(.standard);
  when(repo.isSpeechModelReady).thenReturn(false);
  when(repo.workspace).thenReturn(null);
  when(repo.autoSave).thenReturn(false);
  final events = StreamController<SpeechModelEvent>.broadcast();
  addTearDown(events.close);
  when(repo.downloadSpeechModel).thenAnswer((_) => events.stream);
  final container = ProviderContainer.test(
    overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return (container: container, events: events, repo: repo);
}

void main() {
  group('downloading the speech model', () {
    test('starts at no progress and shows each progress and verifying step', () async {
      final (:container, :events, repo: _) = _downloading();
      container.read(settingsProvider.notifier).downloadModel();
      expect(
        container.read(settingsProvider).modelDownload,
        equals(const SpeechModelEvent.progress(received: 0, total: 0)),
      );

      events.add(const .progress(received: 5, total: 10));
      await pumpEventQueue();
      expect(
        container.read(settingsProvider).modelDownload,
        equals(const SpeechModelEvent.progress(received: 5, total: 10)),
      );

      events.add(const .verifying('encoder.onnx'));
      await pumpEventQueue();
      expect(
        container.read(settingsProvider).modelDownload,
        equals(const SpeechModelEvent.verifying('encoder.onnx')),
      );
    });

    test('a finished download makes the model ready and clears the progress', () async {
      final (:container, :events, repo: _) = _downloading();
      container.read(settingsProvider.notifier).downloadModel();

      events.add(const .ready());
      await pumpEventQueue();

      final state = container.read(settingsProvider);
      expect(state.modelReady, isTrue);
      expect(state.modelDownload, isNull);
    });

    test('a failed download keeps its reason and can be started again', () async {
      final (:container, :events, :repo) = _downloading();
      final notifier = container.read(settingsProvider.notifier)..downloadModel();

      events.add(const .failed(.network));
      await pumpEventQueue();

      final state = container.read(settingsProvider);
      expect(state.modelReady, isFalse);
      expect(state.modelDownload, equals(const SpeechModelEvent.failed(.network)));

      notifier.downloadModel();
      verify(repo.downloadSpeechModel).called(2);
    });

    test('a second start while one is running does not start another download', () {
      final (:container, events: _, :repo) = _downloading();
      final notifier = container.read(settingsProvider.notifier);

      notifier.downloadModel();
      notifier.downloadModel();

      verify(repo.downloadSpeechModel).called(1);
    });
  });
}
