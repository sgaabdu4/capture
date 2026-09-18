import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttp extends Mock implements INotionHttpService {}

/// A Notion workspace in memory with one shared page, `parent`, answering
/// the requests setup makes in the shapes the live API returns. [created]
/// lists every page and database created.
final class _Notion {
  _Notion() {
    when(() => http.get(any(), token: any(named: 'token'))).thenAnswer((call) async {
      final path = call.positionalArguments.whereType<String>().single;
      return .ok(_get(Uri.parse(path).pathSegments.skip(1).toList()));
    });
    when(() => http.post(any(), any(), token: any(named: 'token'))).thenAnswer((call) async {
      final [path as String, body as Json] = call.positionalArguments;
      return .ok(path == '/v1/pages' ? _page(body) : _database(body));
    });
  }

  final http = _MockHttp();
  final created = <String>[];
  final _children = <String, List<Json>>{'parent': []};
  final _sources = <String, String>{};

  Json _get(List<String> path) => switch (path) {
    ['blocks', final id, 'children'] => {'results': _children[id] ?? [], 'has_more': false},
    ['databases', final id] => {
      'data_sources': [
        {'id': _sources[id]},
      ],
    },
    _ => {'bot': <String, Object?>{}},
  };

  Json _page(Json body) {
    final id = 'page-${created.length}';
    created.add(id);
    _children['parent']!.add({
      'type': 'child_page',
      'id': id,
      'child_page': {'title': 'Capture'},
    });
    _children[id] = [...(body['children']! as List<Object?>).whereType<Json>()];
    return {'id': id};
  }

  Json _database(Json body) {
    final id = 'db-${created.length}';
    created.add(id);
    final parent = switch (body) {
      {'parent': {'page_id': final String page}} => page,
      _ => fail('A database without a parent page'),
    };
    _sources[id] = 'source-$id';
    _children[parent]!.add({
      'type': 'child_database',
      'id': id,
      'child_database': {'title': plainText(body['title'])},
    });
    return {
      'id': id,
      'data_sources': [
        {'id': 'source-$id'},
      ],
    };
  }
}

void main() {
  setUpAll(() => registerFallbackValue(<String, Object?>{}));

  test('setting up again from a fresh Mac finds the Capture area and databases', () async {
    final notion = _Notion();
    final remote = NotionWorkspaceRemoteDatasource(notion.http);

    final first = await remote.connect(token: 'token', parentPageId: 'parent');
    final again = await remote.connect(token: 'token', parentPageId: 'parent');

    expect(notion.created, hasLength(4), reason: 'one area page and three databases');
    expect(again, isA<Ok<Object, NotionFailure>>());
    expect(again, equals(first));
  });
}
