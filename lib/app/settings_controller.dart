import 'dart:async';

import 'package:capture/app/env.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:capture/features/settings/data/datasources/secrets_local_datasource.dart';
import 'package:flutter/foundation.dart';

/// Credentials, Notion connection, groups, speech model and shortcut.
class SettingsController extends ChangeNotifier {
  SettingsController(this._env);
  final AppEnv _env;

  bool hasTypesafeKey = false;
  bool hasNotionToken = false;
  NotionWorkspace? workspace;
  List<Group> groups = const [];
  bool modelReady = false;
  double? modelProgress;
  String? modelStatus;
  String? modelError;
  Shortcut shortcut = Shortcut.defaultShortcut;
  bool shortcutRegistered = false;
  String micPermission = 'undetermined';

  bool get notionConnected => workspace != null && hasNotionToken;
  bool get ready => hasTypesafeKey && notionConnected && modelReady;
  List<Group> get activeGroups => [
    for (final g in groups)
      if (!g.archived) g,
  ];

  Future<void> load() async {
    final store = _env.store;
    final ws = store.getJson('workspace');
    workspace = ws == null ? null : NotionWorkspace.fromJson(ws);
    groups = store.groups();
    final sc = store.getJson('shortcut');
    if (sc != null) shortcut = Shortcut.fromJson(sc);
    hasTypesafeKey = await _env.secrets.read(Secret.typesafeKey) != null;
    hasNotionToken = await _env.secrets.read(Secret.notionToken) != null;
    modelReady = _env.model.isReady;
    micPermission = await _env.native.micPermission();
    shortcutRegistered = await _env.native.setHotKey(
      shortcut.keyCode,
      shortcut.carbonModifiers,
      shortcut.label,
    );
    notifyListeners();
  }

  /// Validates with a harmless model listing before storing in Keychain.
  Future<String?> saveTypesafeKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return 'Paste your TypeSafe API key.';
    final jev = _env.jev(trimmed);
    try {
      await jev.validateKey();
    } on JevException catch (e) {
      return e.userMessage;
    } finally {
      jev.close();
    }
    await _env.secrets.write(Secret.typesafeKey, trimmed);
    hasTypesafeKey = true;
    notifyListeners();
    return null;
  }

  Future<void> forgetTypesafeKey() async {
    await _env.secrets.delete(Secret.typesafeKey);
    hasTypesafeKey = false;
    notifyListeners();
  }

  /// Validates the token, checks the page is shared, then finds or creates
  /// the Capture area. The token is stored only after it works.
  /// Empty fields reuse the stored token / current page (reconnect).
  Future<String?> connectNotion(String token, String pageInput) async {
    final t = token.trim().isEmpty
        ? await _env.secrets.read(Secret.notionToken) ?? ''
        : token.trim();
    final pageId = pageInput.trim().isEmpty ? workspace?.parentPageId : parseNotionId(pageInput);
    if (t.isEmpty) return 'Paste your Notion connection token.';
    if (pageId == null) return 'Paste the link to the Notion page to use.';
    final client = _env.notion(t);
    try {
      final ws = await NotionSetup(client)
          .connect(pageId, known: workspace?.parentPageId == pageId ? workspace : null);
      await _env.secrets.write(Secret.notionToken, t);
      hasNotionToken = true;
      workspace = ws;
      _env.store.setJson('workspace', ws.toJson());
      groups = await NotionSetup(client).fetchGroups(ws.groups);
      _env.store.setGroups(groups);
      notifyListeners();
      return null;
    } on NotionException catch (e) {
      return e.userMessage;
    } finally {
      client.close();
    }
  }

  Future<void> disconnectNotion() async {
    await _env.secrets.delete(Secret.notionToken);
    hasNotionToken = false;
    workspace = null;
    _env.store.setJson('workspace', null);
    notifyListeners();
  }

  Future<T> withNotion<T>(Future<T> Function(NotionClient) run) async {
    final token = await _env.secrets.read(Secret.notionToken);
    if (token == null || workspace == null) {
      throw const NotionException(NotionFailure.invalidToken);
    }
    final client = _env.notion(token);
    try {
      return await run(client);
    } finally {
      client.close();
    }
  }

  Future<String?> refreshGroups() => _groupsCall((setup, ws) async {
    groups = await setup.fetchGroups(ws.groups);
  });

  Future<String?> addGroup(String name, String description) async {
    final problem = validateGroup(name, description, groups);
    if (problem != null) return problem;
    return _groupsCall((setup, ws) async {
      final g = await setup.createGroup(ws.groups, name.trim(), description.trim());
      groups = [...groups, g];
    });
  }

  Future<String?> updateGroup(Group group) async {
    final problem = validateGroup(group.name, group.description, groups, editingId: group.id);
    if (problem != null) return problem;
    return _groupsCall((setup, ws) async {
      await setup.updateGroup(group);
      groups = [for (final g in groups) g.id == group.id ? group : g];
    });
  }

  Future<String?> _groupsCall(Future<void> Function(NotionSetup, NotionWorkspace) run) async {
    try {
      await withNotion((client) => run(NotionSetup(client), workspace!));
    } on NotionException catch (e) {
      return e.userMessage;
    }
    _env.store.setGroups(groups);
    notifyListeners();
    return null;
  }

  StreamSubscription<ModelEvent>? _download;

  void downloadModel() {
    if (_download != null) return;
    modelError = null;
    modelProgress = 0;
    modelStatus = 'Starting download…';
    notifyListeners();
    _download = _env.model.download().listen((event) {
      switch (event) {
        case ModelProgress(:final fraction, :final received, :final total):
          modelProgress = fraction;
          modelStatus = 'Downloading ${received ~/ 1000000} of ${total ~/ 1000000} MB';
        case ModelVerifying(:final file):
          modelStatus = 'Checking $file…';
        case ModelReady():
          modelReady = true;
          modelProgress = null;
          modelStatus = null;
          _download = null;
        case ModelFailed(:final message):
          modelError = message;
          modelProgress = null;
          modelStatus = null;
          _download = null;
      }
      notifyListeners();
    });
  }

  Future<String?> setShortcut(Shortcut s) async {
    final problem = shortcutProblem(s);
    if (problem != null) return problem;
    final ok = await _env.native.setHotKey(s.keyCode, s.carbonModifiers, s.label);
    if (!ok) {
      await _env.native.setHotKey(shortcut.keyCode, shortcut.carbonModifiers, shortcut.label);
      return '${s.label} is already used by another app.';
    }
    shortcut = s;
    shortcutRegistered = true;
    _env.store.setJson('shortcut', s.toJson());
    notifyListeners();
    return null;
  }

  Future<bool> ensureMic() async {
    micPermission = await _env.native.micPermission();
    if (micPermission == 'undetermined') {
      micPermission = await _env.native.requestMic() ? 'granted' : 'denied';
    }
    notifyListeners();
    return micPermission == 'granted';
  }

  @override
  void dispose() {
    unawaited(_download?.cancel());
    super.dispose();
  }
}
