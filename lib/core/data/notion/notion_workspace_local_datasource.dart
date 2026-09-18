import 'dart:convert';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notion_workspace_local_datasource.g.dart';

/// The connected workspace's ids, cached so saves work without re-setup.
abstract interface class INotionWorkspaceLocalDatasource {
  NotionWorkspaceModel? read();
  void write(NotionWorkspaceModel? workspace);
}

@Riverpod(keepAlive: true)
INotionWorkspaceLocalDatasource notionWorkspaceLocalDatasource(Ref ref) =>
    NotionWorkspaceLocalDatasource(ref.read(keyValueLocalDatasourceProvider));

class NotionWorkspaceLocalDatasource implements INotionWorkspaceLocalDatasource {
  NotionWorkspaceLocalDatasource(this._kv);
  final IKeyValueLocalDatasource _kv;

  static const _key = 'workspace';

  @override
  NotionWorkspaceModel? read() => switch (_kv.read(_key)) {
    final String raw => _decode(raw),
    null => null,
  };

  static NotionWorkspaceModel? _decode(String raw) => switch (jsonDecode(raw)) {
    final Map<String, dynamic> json => .fromJson(json),
    _ => null,
  };

  @override
  void write(NotionWorkspaceModel? workspace) =>
      _kv.write(_key, workspace == null ? null : jsonEncode(workspace.toJson()));
}
