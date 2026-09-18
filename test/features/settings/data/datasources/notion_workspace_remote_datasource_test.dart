import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttp extends Mock implements INotionHttpService {}

/// A Notion workspace in memory with one shared page, `parent`, keeping
/// every page and database created in [created].
final class _Workspace {
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
    _ => {'bot': <String, Object?>{}},
  };
}

/// Notion's API over [workspace], in the shapes the live API returns.
_MockHttp _notion(_Workspace workspace) {
  final http = _MockHttp();
  when(() => http.get(any(), token: any(named: 'token'))).thenAnswer(
    (call) async => switch (call.positionalArguments) {
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
}
