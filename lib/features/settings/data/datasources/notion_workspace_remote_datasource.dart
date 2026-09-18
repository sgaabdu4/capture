import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/data/notion/notion_query.dart';
import 'package:capture/core/data/notion/notion_schema.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notion_workspace_remote_datasource.g.dart';

/// Workspace name and upload limit of the token's workspace.
typedef NotionAccount = ({String? workspaceName, int maxUploadBytes});

/// Finds or creates the Capture area and its three data sources inside the
/// page the user shared. Idempotent: an existing marked area is adopted,
/// never duplicated; nothing outside the area is modified.
abstract interface class INotionWorkspaceRemoteDatasource {
  Future<NotionResult<NotionWorkspaceModel>> connect({
    required String token,
    required String parentPageId,
    NotionWorkspaceModel? known,
  });
}

class NotionWorkspaceRemoteDatasource implements INotionWorkspaceRemoteDatasource {
  NotionWorkspaceRemoteDatasource(this._http);
  final INotionHttpService _http;

  /// Notion's free-plan upload limit, used when the API omits it.
  static const _defaultMaxUpload = 5 * 1024 * 1024;

  NotionAccount _account(Json me) => switch (me) {
    {'bot': final Json bot} => (
      workspaceName: switch (bot) {
        {'workspace_name': final String name} when name.isNotEmpty => name,
        _ => null,
      },
      maxUploadBytes: switch (bot) {
        {'workspace_limits': {'max_file_upload_size_in_bytes': final num max}} => max.toInt(),
        _ => _defaultMaxUpload,
      },
    ),
    _ => (workspaceName: null, maxUploadBytes: _defaultMaxUpload),
  };

  @override
  Future<NotionResult<NotionWorkspaceModel>> connect({
    required String token,
    required String parentPageId,
    NotionWorkspaceModel? known,
  }) async {
    final NotionAccount account;
    switch (await _http.get('/v1/users/me', token: token)) {
      case Ok(:final value):
        account = _account(value);
      case Err(:final failure):
        return .err(failure);
    }
    if (await _http.get('/v1/pages/$parentPageId', token: token) case Err(:final failure)) {
      return .err(failure);
    }
    if (known
        case NotionWorkspaceModel(
          parentPageId: final knownParent,
          :final areaPageId,
          :final groups,
          :final captures,
          :final library,
        )
        when knownParent == parentPageId) {
      final kept = await _stillThere([groups, captures, library], token);
      if (kept case Err(:final failure)) return .err(failure);
      if (kept case Ok(value: true)) {
        return .ok(
          _model(
            parentPageId: parentPageId,
            area: areaPageId,
            sources: (groups: groups, captures: captures, library: library),
            account: account,
          ),
        );
      }
    }
    final String area;
    switch (await _findOrCreateArea(parentPageId, token)) {
      case Ok(:final value):
        area = value;
      case Err(:final failure):
        return .err(failure);
    }
    return switch (await _ensureDataSources(area, token)) {
      Ok(:final value) => .ok(
        _model(parentPageId: parentPageId, area: area, sources: value, account: account),
      ),
      Err(:final failure) => .err(failure),
    };
  }

  NotionWorkspaceModel _model({
    required String parentPageId,
    required String area,
    required _DataSources sources,
    required NotionAccount account,
  }) => .new(
    parentPageId: parentPageId,
    areaPageId: area,
    groups: sources.groups,
    captures: sources.captures,
    library: sources.library,
    maxUploadBytes: account.maxUploadBytes,
    workspaceName: account.workspaceName,
  );

  /// False when any of the data sources was trashed or unshared.
  Future<NotionResult<bool>> _stillThere(List<String> dataSourceIds, String token) async {
    for (final id in dataSourceIds) {
      final source = await _http.get('/v1/data_sources/$id', token: token);
      if (source case Ok(value: {'in_trash': true}) || Err(failure: .notShared)) {
        return const .ok(false);
      }
      if (source case Err(:final failure)) return .err(failure);
    }
    return const .ok(true);
  }

  Future<NotionResult<String>> _findOrCreateArea(String parentPageId, String token) async {
    final List<Json> children;
    switch (await childrenOf(_http, parentPageId, token: token)) {
      case Ok(:final value):
        children = value;
      case Err(:final failure):
        return .err(failure);
    }
    for (final child in children) {
      if (child case {
        'type': 'child_page',
        'id': final String id,
        'child_page': {'title': areaTitle},
      }) {
        final marked = await _isMarked(id, token);
        if (marked case Ok(value: true)) return .ok(id);
        if (marked case Err(:final failure)) return .err(failure);
      }
    }
    return createdId(
      await _http.post('/v1/pages', {
        NotionKeys.parent: {NotionKeys.type: 'page_id', NotionKeys.pageId: parentPageId},
        NotionKeys.properties: {NotionKeys.title: titleValue(areaTitle)},
        NotionKeys.children: [block('paragraph', areaMarker)],
      }, token: token),
    );
  }

  Future<NotionResult<bool>> _isMarked(String pageId, String token) async =>
      switch (await childrenOf(_http, pageId, token: token)) {
        Ok(:final value) => .ok(
          value.any(
            (b) => switch (b) {
              {'type': 'paragraph', 'paragraph': {'rich_text': final Object? text}} => plainText(
                text,
              ).startsWith(areaMarkerPrefix),
              _ => false,
            },
          ),
        ),
        Err(:final failure) => .err(failure),
      };

  Future<NotionResult<Map<String, String>>> _findDataSources(String areaId, String token) async {
    final List<Json> children;
    switch (await childrenOf(_http, areaId, token: token)) {
      case Ok(:final value):
        children = value;
      case Err(:final failure):
        return .err(failure);
    }
    final byTitle = <String, String>{};
    for (final child in children) {
      if (child case {
        'type': 'child_database',
        'id': final String id,
        'child_database': {'title': final String title},
      }) {
        final database = await _http.get('/v1/databases/$id', token: token);
        if (database case Err(:final failure)) return .err(failure);
        if (database case Ok(value: {'data_sources': [{'id': final String source}, ...]})) {
          byTitle[title] = source;
        }
      }
    }
    return .ok(byTitle);
  }

  /// Creates whichever databases are missing (a previous setup may have
  /// stopped part-way).
  Future<NotionResult<_DataSources>> _ensureDataSources(String areaId, String token) async {
    final Map<String, String> found;
    switch (await _findDataSources(areaId, token)) {
      case Ok(:final value):
        found = value;
      case Err(:final failure):
        return .err(failure);
    }
    final String groups;
    switch (await _ensure(
      found[NotionValues.groupsDatabase],
      () => _database(areaId, NotionValues.groupsDatabase, groupsSchema, token),
    )) {
      case Ok(:final value):
        groups = value;
      case Err(:final failure):
        return .err(failure);
    }
    final String captures;
    switch (await _ensure(
      found[NotionValues.capturesDatabase],
      () => _database(areaId, NotionValues.capturesDatabase, capturesSchema, token),
    )) {
      case Ok(:final value):
        captures = value;
      case Err(:final failure):
        return .err(failure);
    }
    return switch (await _ensure(
      found[NotionValues.libraryDatabase],
      () => _database(areaId, NotionValues.libraryDatabase, librarySchema(groups, captures), token),
    )) {
      Ok(:final value) => .ok((groups: groups, captures: captures, library: value)),
      Err(:final failure) => .err(failure),
    };
  }

  /// The [existing] data source id, or a new database from [create].
  Future<NotionResult<String>> _ensure(
    String? existing,
    Future<NotionResult<String>> Function() create,
  ) async => switch (existing) {
    final String id => .ok(id),
    null => await create(),
  };

  Future<NotionResult<String>> _database(
    String areaId,
    String title,
    Json properties,
    String token,
  ) async => switch (await _http.post('/v1/databases', {
    NotionKeys.parent: {NotionKeys.type: 'page_id', NotionKeys.pageId: areaId},
    NotionKeys.title: richText(title),
    NotionKeys.isInline: false,
    NotionKeys.initialDataSource: {NotionKeys.properties: properties},
  }, token: token)) {
    Ok(value: {'data_sources': [{'id': final String source}, ...]}) => .ok(source),
    Ok() => const .err(.invalidRequest),
    Err(:final failure) => .err(failure),
  };
}

typedef _DataSources = ({String groups, String captures, String library});

@Riverpod(keepAlive: true)
INotionWorkspaceRemoteDatasource notionWorkspaceRemoteDatasource(Ref ref) =>
    NotionWorkspaceRemoteDatasource(ref.read(notionHttpServiceProvider));
