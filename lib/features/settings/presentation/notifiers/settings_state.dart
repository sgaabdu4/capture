import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

/// Credentials, Notion connection, speech model, shortcut and microphone.
@freezed
sealed class SettingsState with _$SettingsState {
  const SettingsState._();

  const factory SettingsState({
    required Shortcut shortcut,
    required bool modelReady,
    NotionWorkspace? workspace,

    /// False until Keychain, microphone and hotkey state have been read.
    @Default(false) bool loaded,
    @Default(false) bool hasTypesafeKey,
    @Default(false) bool hasNotionToken,
    @Default(false) bool shortcutRegistered,
    ShortcutProblem? shortcutProblem,
    @Default(MicPermission.undetermined) MicPermission mic,

    /// Latest download event while the model downloads or after it failed.
    SpeechModelEvent? modelDownload,
    @Default(false) bool savingKey,
    JevFailure? keyFailure,
    @Default(false) bool connecting,
    NotionFailure? notionFailure,
    @Default(false) bool pageLinkInvalid,
  }) = _SettingsState;

  bool get notionConnected => workspace != null && hasNotionToken;

  /// Everything a capture needs is in place.
  bool get ready => hasTypesafeKey && notionConnected && modelReady;

  bool get downloading => switch (modelDownload) {
    SpeechModelProgress() || SpeechModelVerifying() => true,
    _ => false,
  };
}
