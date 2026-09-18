import 'dart:convert';

import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/library/data/datasources/library_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttp extends Mock implements INotionHttpService {}

Json _paragraph(String blockId, String text) => {
  'id': blockId,
  'type': 'paragraph',
  'paragraph': {
    'rich_text': [
      {'plain_text': text},
    ],
  },
};

/// An item page as Capture writes it: body paragraphs, then the quoted
/// words it came from, then a paragraph the owner added in Notion.
final _children = <Json>[
  _paragraph('p1', 'Buy oat milk'),
  _paragraph('p2', 'and bread'),
  {
    'id': 'q1',
    'type': 'quote',
    'quote': {'rich_text': <Object?>[]},
  },
  _paragraph('p3', 'Added later in Notion'),
];

/// Every PATCH sent, as (path, body).
typedef _Patch = ({String path, Json body});

/// Notion with [_children] on page `page`; records every PATCH into [patches].
_MockHttp _notion(List<_Patch> patches) {
  final http = _MockHttp();
  when(() => http.get(any(), token: any(named: 'token')))
      .thenAnswer((_) async => .ok({'results': _children, 'has_more': false}));
  when(() => http.patch(any(), any(), token: any(named: 'token'))).thenAnswer((call) async {
    if (call.positionalArguments case [final String path, final Json body]) {
      patches.add((path: path, body: body));
    }
    return const .ok({});
  });
  return http;
}

void main() {
  test('the body is the leading paragraphs only', () async {
    final remote = LibraryRemoteDatasource(_notion([]));

    final body = switch (await remote.body('page')) {
      Ok(:final value) => value,
      Err(:final failure) => fail('$failure'),
    };

    expect(body.text, equals('Buy oat milk\nand bread'));
    expect(body.blockIds, equals(['p1', 'p2']));
  });

  test('a new body trashes the old paragraphs and goes on top, leaving the rest', () async {
    final patches = <_Patch>[];
    final remote = LibraryRemoteDatasource(_notion(patches));

    await remote.replaceBody('page', (text: 'old', blockIds: ['p1', 'p2']), 'Buy soy milk');

    expect(
      patches.map((p) => p.path),
      equals(['/v1/blocks/p1', '/v1/blocks/p2', '/v1/blocks/page/children']),
    );
    expect(patches.take(2).map((p) => p.body), everyElement(equals({'in_trash': true})));
    expect(patches.last.body['position'], equals({'type': 'start'}));
    expect(jsonEncode(patches.last.body['children']), contains('Buy soy milk'));
  });

  test('deleting moves the page to Notion trash', () async {
    final patches = <_Patch>[];

    await LibraryRemoteDatasource(_notion(patches)).trash('page');

    expect(patches.map((p) => p.path), equals(['/v1/pages/page']));
    expect(
      patches.map((p) => p.body),
      equals([
        {'in_trash': true},
      ]),
    );
  });
}
