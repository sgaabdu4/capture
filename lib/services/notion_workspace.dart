import '../domain/models.dart';
import 'notion_client.dart';
import 'notion_shapes.dart';

/// The Capture area inside the user's authorised Notion page.
class NotionWorkspace {
  const NotionWorkspace({
    required this.parentPageId,
    required this.areaPageId,
    required this.groups,
    required this.captures,
    required this.library,
    required this.maxUploadBytes,
    this.workspaceName = '',
  });

  factory NotionWorkspace.fromJson(Map<String, Object?> json) =>
      NotionWorkspace(
        parentPageId: json['parentPageId']! as String,
        areaPageId: json['areaPageId']! as String,
        groups: json['groups']! as String,
        captures: json['captures']! as String,
        library: json['library']! as String,
        maxUploadBytes: json['maxUploadBytes']! as int,
        workspaceName: json['workspaceName'] as String? ?? '',
      );

  final String parentPageId;
  final String areaPageId;

  /// Data source ids.
  final String groups;
  final String captures;
  final String library;
  final int maxUploadBytes;
  final String workspaceName;

  Map<String, Object?> toJson() => {
    'parentPageId': parentPageId,
    'areaPageId': areaPageId,
    'groups': groups,
    'captures': captures,
    'library': library,
    'maxUploadBytes': maxUploadBytes,
    'workspaceName': workspaceName,
  };
}

const areaTitle = 'Capture';
const areaMarker =
    'Managed by the Capture app. Rename pages freely, but keep the Groups, '
    'Captures and Library databases here.';

/// Property names written by the app.
abstract final class P {
  static const name = 'Name';
  static const description = 'Description';
  static const status = 'Status';
  static const captureId = 'Capture ID';
  static const capturedAt = 'Captured at';
  static const timeZone = 'Time zone';
  static const duration = 'Duration (s)';
  static const recording = 'Recording';
  static const itemId = 'Item ID';
  static const kind = 'Kind';
  static const group = 'Group';
  static const capture = 'Capture';
  static const done = 'Done';
  static const due = 'Due';
  static const reminder = 'Reminder';
}

Map<String, Object?> _select(List<(String, String)> options) => {
  'select': {
    'options': [
      for (final (name, color) in options) {'name': name, 'color': color},
    ],
  },
};

final _groupsSchema = <String, Object?>{
  P.name: {'title': <String, Object?>{}},
  P.description: {'rich_text': <String, Object?>{}},
  P.status: _select([('Active', 'green'), ('Archived', 'gray')]),
};

final _capturesSchema = <String, Object?>{
  P.name: {'title': <String, Object?>{}},
  P.captureId: {'rich_text': <String, Object?>{}},
  P.capturedAt: {'date': <String, Object?>{}},
  P.timeZone: {'rich_text': <String, Object?>{}},
  P.duration: {
    'number': {'format': 'number'},
  },
  P.recording: {'files': <String, Object?>{}},
  P.status: _select([('Incomplete', 'yellow'), ('Saved', 'green')]),
};

Map<String, Object?> _librarySchema(String groups, String captures) => {
  P.name: {'title': <String, Object?>{}},
  P.itemId: {'rich_text': <String, Object?>{}},
  P.kind: _select([('Note', 'blue'), ('Task', 'orange')]),
  P.group: {
    'relation': {
      'data_source_id': groups,
      'type': 'single_property',
      'single_property': <String, Object?>{},
    },
  },
  P.capture: {
    'relation': {
      'data_source_id': captures,
      'type': 'dual_property',
      'dual_property': {'synced_property_name': 'Items'},
    },
  },
  P.done: {'checkbox': <String, Object?>{}},
  P.due: {'date': <String, Object?>{}},
  P.reminder: {'date': <String, Object?>{}},
};

/// Finds or creates the Capture area, its three data sources and the
/// default groups. Idempotent: an existing marked area is adopted, never
/// duplicated; nothing outside the area is modified.
class NotionSetup {
  const NotionSetup(this._client);
  final NotionClient _client;

  /// Validates the token and returns the workspace name and upload limit.
  Future<(String, int)> checkToken() async {
    final me = await _client.get('/v1/users/me');
    final bot = me['bot'] as Map<String, Object?>? ?? const {};
    final limits = bot['workspace_limits'] as Map<String, Object?>?;
    return (
      bot['workspace_name'] as String? ?? '',
      (limits?['max_file_upload_size_in_bytes'] as num?)?.toInt() ?? 5242880,
    );
  }

  Future<NotionWorkspace> connect(
    String parentPageId, {
    NotionWorkspace? known,
  }) async {
    final (workspaceName, maxUpload) = await checkToken();
    await _client.get('/v1/pages/$parentPageId');
    NotionWorkspace build(String area, List<String> ds) => NotionWorkspace(
      parentPageId: parentPageId,
      areaPageId: area,
      groups: ds[0],
      captures: ds[1],
      library: ds[2],
      maxUploadBytes: maxUpload,
      workspaceName: workspaceName,
    );
    if (known != null &&
        known.parentPageId == parentPageId &&
        await _stillThere(known)) {
      return build(known.areaPageId, [
        known.groups,
        known.captures,
        known.library,
      ]);
    }
    final area =
        await _findArea(parentPageId) ?? await _createArea(parentPageId);
    return build(area, await _ensureDataSources(area));
  }

  Future<bool> _stillThere(NotionWorkspace w) async {
    try {
      for (final id in [w.groups, w.captures, w.library]) {
        final ds = await _client.get('/v1/data_sources/$id');
        if (ds['in_trash'] == true) return false;
      }
      return true;
    } on NotionException catch (e) {
      if (e.failure == NotionFailure.notShared) return false;
      rethrow;
    }
  }

  Future<List<Map<String, Object?>>> _children(String blockId) async {
    final out = <Map<String, Object?>>[];
    String? cursor;
    do {
      final page = await _client.get(
        '/v1/blocks/$blockId/children?page_size=100'
        '${cursor == null ? '' : '&start_cursor=$cursor'}',
      );
      out.addAll((page['results'] as List<Object?>).cast());
      cursor = page['has_more'] == true ? page['next_cursor'] as String? : null;
    } while (cursor != null);
    return out;
  }

  Future<String?> _findArea(String parentPageId) async {
    for (final child in await _children(parentPageId)) {
      if (child['type'] != 'child_page') continue;
      final title =
          (child['child_page'] as Map<String, Object?>?)?['title'] as String?;
      if (title != areaTitle) continue;
      final id = child['id']! as String;
      final inner = await _children(id);
      final marked = inner.any(
        (b) =>
            b['type'] == 'paragraph' &&
            plainText((b['paragraph'] as Map<String, Object?>?)?['rich_text'])
                .startsWith('Managed by the Capture app'),
      );
      if (marked) return id;
    }
    return null;
  }

  Future<Map<String, String>> _findDataSources(String areaId) async {
    final byTitle = <String, String>{};
    for (final child in await _children(areaId)) {
      if (child['type'] != 'child_database') continue;
      final title =
          (child['child_database'] as Map<String, Object?>?)?['title']
              as String?;
      if (title == null) continue;
      final db = await _client.get('/v1/databases/${child['id']}');
      final sources = db['data_sources'] as List<Object?>? ?? const [];
      if (sources.isEmpty) continue;
      byTitle[title] =
          (sources.first! as Map<String, Object?>)['id']! as String;
    }
    return byTitle;
  }

  Future<String> _createArea(String parentPageId) async {
    final area = await _client.post('/v1/pages', {
      'parent': {'type': 'page_id', 'page_id': parentPageId},
      'properties': {'title': titleValue(areaTitle)},
      'children': [block('paragraph', areaMarker)],
    });
    return area['id']! as String;
  }

  /// Creates whichever databases are missing (a previous setup may have
  /// stopped part-way) and seeds default groups into an empty Groups.
  Future<List<String>> _ensureDataSources(String areaId) async {
    final found = await _findDataSources(areaId);
    final groups =
        found['Groups'] ?? await _database(areaId, 'Groups', _groupsSchema);
    final captures =
        found['Captures'] ??
        await _database(areaId, 'Captures', _capturesSchema);
    final library =
        found['Library'] ??
        await _database(areaId, 'Library', _librarySchema(groups, captures));
    if ((await fetchGroups(groups)).isEmpty) {
      for (final g in defaultGroups) {
        await createGroup(groups, g.name, g.description);
      }
    }
    return [groups, captures, library];
  }

  Future<String> _database(
    String areaId,
    String title,
    Map<String, Object?> properties,
  ) async {
    final db = await _client.post('/v1/databases', {
      'parent': {'type': 'page_id', 'page_id': areaId},
      'title': richText(title),
      'is_inline': false,
      'initial_data_source': {'properties': properties},
    });
    final sources = db['data_sources']! as List<Object?>;
    return (sources.first! as Map<String, Object?>)['id']! as String;
  }

  Future<List<Group>> fetchGroups(String dataSource) async {
    final pages = await queryAll(_client, dataSource, const {});
    return [
      for (final p in pages)
        Group(
          id: p['id']! as String,
          name: propText(p, P.name),
          description: propText(p, P.description),
          archived: propSelect(p, P.status) == 'Archived',
        ),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<Group> createGroup(
    String dataSource,
    String name,
    String description,
  ) async {
    final page = await _client.post('/v1/pages', {
      'parent': {'type': 'data_source_id', 'data_source_id': dataSource},
      'properties': {
        P.name: titleValue(name),
        P.description: textValue(description),
        P.status: selectValue('Active'),
      },
    });
    return Group(
      id: page['id']! as String,
      name: name,
      description: description,
    );
  }

  Future<void> updateGroup(Group group) =>
      _client.patch('/v1/pages/${group.id}', {
        'properties': {
          P.name: titleValue(group.name),
          P.description: textValue(group.description),
          P.status: selectValue(group.archived ? 'Archived' : 'Active'),
        },
      });
}

/// Every page of a data source query (follows cursors).
Future<List<Map<String, Object?>>> queryAll(
  NotionClient client,
  String dataSource,
  Map<String, Object?> body,
) async {
  final out = <Map<String, Object?>>[];
  String? cursor;
  do {
    final page = await client.post('/v1/data_sources/$dataSource/query', {
      ...body,
      'page_size': 100,
      'start_cursor': ?cursor,
    });
    out.addAll((page['results'] as List<Object?>).cast());
    cursor = page['has_more'] == true ? page['next_cursor'] as String? : null;
  } while (cursor != null);
  return out;
}
