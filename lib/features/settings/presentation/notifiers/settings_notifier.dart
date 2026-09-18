import 'dart:async';

import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_state.dart';
import 'package:capture/features/settings/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  StreamSubscription<SpeechModelEvent>? _download;

  @override
  SettingsState build() {
    ref.onDispose(() => unawaited(_download?.cancel()));
    final repo = ref.read(settingsRepositoryProvider);
    return .new(
      shortcut: repo.shortcut(),
      modelReady: repo.isSpeechModelReady(),
      workspace: repo.workspace(),
    );
  }

  /// Reads Keychain and microphone state and registers the hotkey.
  Future<void> load() async {
    final repo = _ensureRepository();
    final native = _ensureNative();
    final hasKey = await repo.hasTypesafeKey();
    if (!ref.mounted) return;
    final hasToken = await repo.hasNotionToken();
    if (!ref.mounted) return;
    final mic = await native.micPermission();
    if (!ref.mounted) return;
    final registered = await _register(state.shortcut);
    if (!ref.mounted) return;
    state = state.copyWith(
      loaded: true,
      hasTypesafeKey: hasKey,
      hasNotionToken: hasToken,
      mic: mic,
      shortcutRegistered: registered,
    );
  }

  ISettingsRepository _ensureRepository() => ref.read(settingsRepositoryProvider);

  INativePlatformService _ensureNative() => ref.read(nativePlatformServiceProvider);

  Future<bool> _register(Shortcut s) async => switch (s.keyCode) {
    final int code => await _ensureNative().setHotKey(
      keyCode: code,
      modifiers: s.carbonModifiers,
      label: s.label,
    ),
    null => false,
  };

  /// Validates with a harmless model listing, then stores in Keychain.
  Future<void> saveTypesafeKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty || state.savingKey) return;
    _startSavingKey();
    final result = await _ensureRepository().saveTypesafeKey(trimmed);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => state.copyWith(savingKey: false, hasTypesafeKey: true),
      Err(:final failure) => state.copyWith(savingKey: false, keyFailure: failure),
    };
  }

  void _startSavingKey() => state = state.copyWith(savingKey: true, keyFailure: null);

  void _startConnecting() =>
      state = state.copyWith(connecting: true, pageLinkInvalid: false, notionFailure: null);

  /// Empty fields reuse the stored token / current page (reconnect).
  Future<void> connectNotion({required String token, required String pageLink}) async {
    if (state.connecting) return;
    final link = pageLink.trim();
    final pageId = link.isEmpty ? state.workspace?.parentPageId : parseNotionId(link);
    if (pageId == null) {
      _rejectPageLink();
      return;
    }
    _startConnecting();
    final trimmed = token.trim();
    final result = await _ensureRepository().connectNotion(
      parentPageId: pageId,
      token: trimmed.isEmpty ? null : trimmed,
    );
    if (!ref.mounted) return;
    switch (result) {
      case Ok(:final value):
        state = state.copyWith(connecting: false, workspace: value, hasNotionToken: true);
        ref.read(groupsProvider.notifier).reload();
        unawaited(ref.read(libraryProvider.notifier).refresh());
      case Err(:final failure):
        state = state.copyWith(connecting: false, notionFailure: failure);
    }
  }

  Future<void> disconnectNotion() async {
    await _ensureRepository().disconnectNotion();
    if (!ref.mounted) return;
    state = state.copyWith(workspace: null, hasNotionToken: false);
  }

  void _rejectPageLink() => state = state.copyWith(pageLinkInvalid: true, notionFailure: null);

  /// Resumable; progress and failure are kept in state.
  void downloadModel() {
    if (_download != null || state.modelReady) return;
    state = state.copyWith(modelDownload: const .progress(received: 0, total: 0));
    _download = _ensureRepository().downloadSpeechModel().listen((event) {
      if (!ref.mounted) return;
      switch (event) {
        case SpeechModelReady():
          _download = null;
          state = state.copyWith(modelReady: true, modelDownload: null);
        case SpeechModelFailed():
          _download = null;
          state = state.copyWith(modelDownload: event);
        case SpeechModelProgress() || SpeechModelVerifying():
          state = state.copyWith(modelDownload: event);
      }
    });
  }

  /// Registers [next] globally; keeps the previous shortcut when macOS says
  /// another app owns it.
  Future<void> setShortcut(Shortcut next) async {
    if (next.problem case final ShortcutProblem problem) {
      _rejectShortcut(problem);
      return;
    }
    final registered = await _register(next);
    if (!ref.mounted) return;
    if (registered) {
      _ensureRepository().saveShortcut(next);
      state = state.copyWith(shortcut: next, shortcutRegistered: true, shortcutProblem: null);
      return;
    }
    final restored = await _register(state.shortcut);
    if (!ref.mounted) return;
    state = state.copyWith(shortcutRegistered: restored, shortcutProblem: .taken);
  }

  void _rejectShortcut(ShortcutProblem problem) => state = state.copyWith(shortcutProblem: problem);

  /// Asks macOS once; true when recording is allowed.
  Future<bool> ensureMic() async {
    final native = _ensureNative();
    final MicPermission current = await native.micPermission();
    final MicPermission mic = switch (current) {
      .undetermined => await native.requestMic() ? .granted : .denied,
      _ => current,
    };
    if (!ref.mounted) return false;
    state = state.copyWith(mic: mic);
    return mic == .granted;
  }
}
