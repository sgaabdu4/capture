import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/domain/values/result.dart';

/// Largest page Notion returns per request.
const notionPageSize = 100;

/// Every page of a data source query (follows cursors).
Future<NotionResult<List<Json>>> queryAll(
  INotionHttpService http,
  String dataSource, {
  Json body = const {},
}) => _collect(
  (cursor) => http.post('/v1/data_sources/$dataSource/query', {
    ...body,
    NotionKeys.pageSize: notionPageSize,
    NotionKeys.startCursor: ?cursor,
  }),
);

/// Every child block of a page (follows cursors).
Future<NotionResult<List<Json>>> childrenOf(
  INotionHttpService http,
  String blockId, {
  String? token,
}) => _collect((cursor) {
  final after = cursor == null ? '' : '&start_cursor=$cursor';
  return http.get('/v1/blocks/$blockId/children?page_size=$notionPageSize$after', token: token);
});

Future<NotionResult<List<Json>>> _collect(
  Future<NotionResult<Json>> Function(String? cursor) page,
) async {
  final out = <Json>[];
  String? cursor;
  do {
    switch (await page(cursor)) {
      case Err(:final failure):
        return .err(failure);
      case Ok(:final value):
        if (value case {'results': final List<Object?> results}) {
          out.addAll(results.whereType<Json>());
        }
        cursor = switch (value) {
          {'has_more': true, 'next_cursor': final String next} => next,
          _ => null,
        };
    }
  } while (cursor != null);
  return .ok(out);
}

/// The `id` of a Notion object.
String? idOf(Json object) => switch (object) {
  {'id': final String id} => id,
  _ => null,
};

/// The id of a created object, or a failure when Notion returned none.
NotionResult<String> createdId(NotionResult<Json> created) => switch (created) {
  Ok(:final value) => _requiredId(value),
  Err(:final failure) => .err(failure),
};

NotionResult<String> _requiredId(Json object) => switch (idOf(object)) {
  final String id => .ok(id),
  null => const .err(.invalidRequest),
};

/// Drops the response body of a successful write.
NotionResult<void> doneWith(NotionResult<Json> result) => switch (result) {
  Ok() => const .ok(null),
  Err(:final failure) => .err(failure),
};
