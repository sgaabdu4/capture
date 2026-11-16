import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttp extends Mock implements INotionHttpService {}

final class _Workspace {
  Json bot = {};
  final failures = <String, NotionFailure>{};
  final created = <String>[];
  final _blocks = <String, List<Json>>{'parent': []};
  final _sources = <String, String>{};

  Json page(Json body) {
    final pageId = 'page-${created.length}';
    created.add(pageId);
    _blocks['parent']?.add({
      'type': 'child_page',
      'id': pageId,
      'child_page': {'title': 'Capture'},
    });
    _blocks[pageId] = switch (body) {
      {'children': final List<Object?> blocks} => [...blocks.whereType<Json>()],
      _ => [],
    };
    return {'id': pageId};
  }

  Json database(Json body) {
    final databaseId = 'db-${created.length}';
    final sourceId = 'source-$databaseId';
    created.add(databaseId);
    _sources[databaseId] = sourceId;
    final area = switch (body) {
      {'parent': {'page_id': final String parent}} => parent,
      _ => fail('A database without a parent page'),
    };
    _blocks[area]?.add({
      'type': 'child_database',
      'id': databaseId,
      'child_database': {'title': plainText(body['title'])},
    });
    return {
      'id': databaseId,
      'data_sources': [
        {'id': sourceId},
      ],
    };
  }

  Json read(String path) => switch (Uri.parse(path).pathSegments) {
    [_, 'blocks', final blockId, 'children'] => {
      'results': _blocks[blockId] ?? [],
      'has_more': false,
    },
    [_, 'databases', final databaseId] => {
      'data_sources': [
        {'id': _sources[databaseId]},
      ],
    },
    _ => {'bot': bot},
  };
}

/// Notion's API over [workspace], in the shapes the live API returns.
_MockHttp _notion(_Workspace workspace) {
  final http = _MockHttp();
  when(() => http.get(any(), token: any(named: 'token'))).thenAnswer(
    (call) async => switch (call.positionalArguments) {
      [final String path] when workspace.failures.containsKey(path) => .err(
        workspace.failures[path] ?? .network,
      ),
      [final String path] => .ok(workspace.read(path)),
      _ => fail('GET without a path'),
    },
  );
  when(() => http.post(any(), any(), token: any(named: 'token'))).thenAnswer(
    (call) async => switch (call.positionalArguments) {
      ['/v1/pages', final Json body] => .ok(workspace.page(body)),
      ['/v1/databases', final Json body] => .ok(workspace.database(body)),
      _ => fail('Unexpected POST'),
    },
  );
  return http;
}

void main() {
  setUpAll(() => registerFallbackValue(<String, Object?>{}));

  test('setting up again from a fresh Mac finds the Capture area and databases', () async {
    final workspace = _Workspace();
    final http = _notion(workspace);

    final first = await NotionWorkspaceRemoteDatasource(http)
        .connect(token: 'token', parentPageId: 'parent');
    final freshMac = NotionWorkspaceRemoteDatasource(http);
    final again = await freshMac.connect(token: 'token', parentPageId: 'parent');

    expect(workspace.created, hasLength(4), reason: 'one area page and three databases');
    expect(again, isA<Ok<Object, NotionFailure>>());
    expect(again, equals(first));
  });

  test('a link to the Capture page itself reuses it instead of nesting a new one', () async {
    final workspace = _Workspace();
    final http = _notion(workspace);
    final first = await NotionWorkspaceRemoteDatasource(http)
        .connect(token: 'token', parentPageId: 'parent');
    final area = switch (first) {
      Ok(value: NotionWorkspaceModel(:final areaPageId)) => areaPageId,
      Err() => fail('The first setup failed'),
    };

    final freshMac = NotionWorkspaceRemoteDatasource(http);
    final linked = await freshMac.connect(token: 'token', parentPageId: area);

    expect(workspace.created, hasLength(4), reason: 'nothing created inside the Capture page');
    expect(linked.valueOrNull?.areaPageId, equals(area));
    expect(linked.valueOrNull?.library, equals(first.valueOrNull?.library));
  });

  group('the account behind the token', () {
    test('gives the workspace name and its upload limit', () async {
      final workspace = _Workspace()
        ..bot = {
          'workspace_name': 'Acme',
          'workspace_limits': {'max_file_upload_size_in_bytes': 1000},
        };

      final connected = await NotionWorkspaceRemoteDatasource(_notion(workspace))
          .connect(token: 'token', parentPageId: 'parent');

      expect(connected.valueOrNull?.workspaceName, equals('Acme'));
      expect(connected.valueOrNull?.maxUploadBytes, equals(1000));
    });

    test('falls back to the free-plan limit and no name when Notion omits them', () async {
      final connected = await NotionWorkspaceRemoteDatasource(_notion(_Workspace()))
          .connect(token: 'token', parentPageId: 'parent');

      expect(connected.valueOrNull?.workspaceName, isNull);
      expect(connected.valueOrNull?.maxUploadBytes, equals(5 * 1024 * 1024));
    });
  });

  group('a connection that fails', () {
    test('stops when the token is refused', () async {
      final workspace = _Workspace()..failures['/v1/users/me'] = .invalidToken;

      final connected = await NotionWorkspaceRemoteDatasource(_notion(workspace))
          .connect(token: 'token', parentPageId: 'parent');

      expect(
        connected,
        equals(const Result<NotionWorkspaceModel, NotionFailure>.err(.invalidToken)),
      );
      expect(workspace.created, isEmpty);
    });

    test('stops when the page is not shared with the integration', () async {
      final workspace = _Workspace()..failures['/v1/pages/parent'] = .notShared;

      final connected = await NotionWorkspaceRemoteDatasource(_notion(workspace))
          .connect(token: 'token', parentPageId: 'parent');

      expect(connected, equals(const Result<NotionWorkspaceModel, NotionFailure>.err(.notShared)));
      expect(workspace.created, isEmpty);
    });
  });

  group('connecting again to the workspace already known', () {
    test('keeps it without creating or searching anything', () async {
      final workspace = _Workspace();
      final http = _notion(workspace);
      final datasource = NotionWorkspaceRemoteDatasource(http);
      final first = await datasource.connect(token: 'token', parentPageId: 'parent');
      clearInteractions(http);

      final again = await datasource.connect(
        token: 'token',
        parentPageId: 'parent',
        known: first.valueOrNull,
      );

      expect(again, equals(first));
      expect(workspace.created, hasLength(4));
      verifyNever(
        () => http.get('/v1/blocks/parent/children?page_size=100', token: any(named: 'token')),
      );
    });

    test('reports a failure to check that its data sources still exist', () async {
      final workspace = _Workspace();
      final http = _notion(workspace);
      final datasource = NotionWorkspaceRemoteDatasource(http);
      final first = await datasource.connect(token: 'token', parentPageId: 'parent');
      final groups = first.valueOrNull?.groups ?? '';
      workspace.failures['/v1/data_sources/$groups'] = .unavailable;

      final again = await datasource.connect(
        token: 'token',
        parentPageId: 'parent',
        known: first.valueOrNull,
      );

      expect(again, equals(const Result<NotionWorkspaceModel, NotionFailure>.err(.unavailable)));
    });
  });
}
