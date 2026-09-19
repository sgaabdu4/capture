import 'dart:io';

import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_workspace_local_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/settings/data/datasources/local_data_datasource.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:capture/features/settings/data/datasources/shortcut_local_datasource.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/domain/entities/speech_model_failure.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository.g.dart';

/// Credentials (Keychain only), the Notion connection, the shortcut and the
/// speech model.
abstract interface class ISettingsRepository {
  Future<bool> hasTypesafeKey();

  /// Validates with a harmless model listing, then stores in Keychain.
  Future<JevOutcome<void>> saveTypesafeKey(String key);
  Future<bool> hasNotionToken();
  NotionWorkspace? workspace();

  /// Validates the token (the stored one when [token] is null), checks the
  /// page is shared, finds or creates the Capture area and seeds groups.
  /// The token is stored only after all of that works.
  Future<NotionResult<NotionWorkspace>> connectNotion({
    required String parentPageId,
    String? token,
  });
  Future<void> disconnectNotion();
  Shortcut shortcut();
  void saveShortcut(Shortcut shortcut);
  bool isSpeechModelReady();
  Stream<SpeechModelEvent> downloadSpeechModel();

  /// Forgets both keys, the Notion link, the shortcut and every local
  /// capture, recording and reminder. The speech model stays.
  Future<void> reset();
}

/// The Notion connection: remote checks, the cached workspace and the
/// groups seeded into it.
typedef NotionConnectionSources = ({
  INotionWorkspaceRemoteDatasource remote,
  INotionWorkspaceLocalDatasource cache,
  IGroupsRepository groups,
});

/// Settings and data that live only on this Mac.
typedef DeviceSettingsSources = ({
  IShortcutLocalDatasource shortcuts,
  ISpeechModelDatasource speechModel,
  ILocalDataDatasource localData,
});

class SettingsRepository implements ISettingsRepository {
  SettingsRepository({
    required this._secrets,
    required this._jev,
    required NotionConnectionSources notion,
    required DeviceSettingsSources device,
  }) : _notion = notion.remote,
       _workspaceCache = notion.cache,
       _groups = notion.groups,
       _shortcuts = device.shortcuts,
       _speechModel = device.speechModel,
       _localData = device.localData;

  final ISecretsLocalDatasource _secrets;
  final IJevRemoteDatasource _jev;
  final INotionWorkspaceRemoteDatasource _notion;
  final INotionWorkspaceLocalDatasource _workspaceCache;
  final IGroupsRepository _groups;
  final IShortcutLocalDatasource _shortcuts;
  final ISpeechModelDatasource _speechModel;
  final ILocalDataDatasource _localData;

  @override
  Future<bool> hasTypesafeKey() async => await _secrets.read(.typesafeKey) != null;

  @override
  Future<JevOutcome<void>> saveTypesafeKey(String key) async {
    final valid = await _jev.validateKey(key);
    if (valid is Ok) await _secrets.write(.typesafeKey, key);
    return valid;
  }

  @override
  Future<bool> hasNotionToken() async => await _secrets.read(.notionToken) != null;

  @override
  NotionWorkspace? workspace() => _workspaceCache.read()?.toEntity();

  @override
  Future<NotionResult<NotionWorkspace>> connectNotion({
    required String parentPageId,
    String? token,
  }) async {
    final secret = token ?? await _secrets.read(.notionToken);
    if (secret == null) return const .err(.invalidToken);
    final known = _workspaceCache.read();
    final NotionWorkspaceModel model;
    switch (await _notion.connect(
      token: secret,
      parentPageId: parentPageId,
      known: known?.parentPageId == parentPageId ? known : null,
    )) {
      case Ok(:final value):
        model = value;
      case Err(:final failure):
        return .err(failure);
    }
    await _secrets.write(.notionToken, secret);
    _workspaceCache.write(model);
    final workspace = model.toEntity();
    return switch (await _groups.seedIfEmpty(workspace)) {
      Ok() => .ok(workspace),
      Err(:final failure) => .err(failure),
    };
  }

  @override
  Future<void> disconnectNotion() async {
    await _secrets.delete(.notionToken);
    _workspaceCache.write(null);
  }

  @override
  Shortcut shortcut() => _shortcuts.read()?.toEntity() ?? .standard;

  @override
  void saveShortcut(Shortcut shortcut) => _shortcuts.write(.fromEntity(shortcut));

  @override
  bool isSpeechModelReady() => _speechModel.isReady();

  /// Network and disk exceptions from the download end it as a failed
  /// event; the next attempt resumes where it stopped.
  @override
  Stream<SpeechModelEvent> downloadSpeechModel() async* {
    try {
      await for (final event in _speechModel.download()) {
        yield event;
      }
    } on Object catch (error) {
      yield .failed(_downloadFailure(error));
    }
  }

  @override
  Future<void> reset() async {
    for (final secret in Secret.values) {
      await _secrets.delete(secret);
    }
    await _localData.erase();
  }

  static SpeechModelFailure _downloadFailure(Object error) => switch (error) {
    SocketException() || http.ClientException() => .network,
    FileSystemException() => .diskSpace,
    _ => .unknown,
  };
}

@Riverpod(keepAlive: true)
ISettingsRepository settingsRepository(Ref ref) => SettingsRepository(
  secrets: ref.read(secretsLocalDatasourceProvider),
  jev: ref.read(jevRemoteDatasourceProvider),
  notion: (
    remote: ref.read(notionWorkspaceRemoteDatasourceProvider),
    cache: ref.read(notionWorkspaceLocalDatasourceProvider),
    groups: ref.read(groupsRepositoryProvider),
  ),
  device: (
    shortcuts: ref.read(shortcutLocalDatasourceProvider),
    speechModel: ref.read(speechModelDatasourceProvider),
    localData: ref.read(localDataDatasourceProvider),
  ),
);
