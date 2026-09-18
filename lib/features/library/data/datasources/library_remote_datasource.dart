import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/data/notion/notion_query.dart';
import 'package:capture/core/data/notion/notion_schema.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/models/due_date_model.dart';
import 'package:capture/features/library/data/models/library_entry_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_remote_datasource.g.dart';

/// The Library data source in Notion (source of truth for saved items).
abstract interface class ILibraryRemoteDatasource {
  Future<NotionResult<List<LibraryEntryModel>>> fetch(String dataSource);
  Future<NotionResult<void>> setDone(String pageId, {required bool done});
}

class LibraryRemoteDatasource implements ILibraryRemoteDatasource {
  LibraryRemoteDatasource(this._http);
  final INotionHttpService _http;

  @override
  Future<NotionResult<List<LibraryEntryModel>>> fetch(String dataSource) async =>
      switch (await queryAll(
        _http,
        dataSource,
        body: {
          NotionKeys.sorts: [
            {NotionKeys.timestamp: 'created_time', NotionKeys.direction: 'descending'},
          ],
        },
      )) {
        Ok(:final value) => .ok([
          for (final page in value)
            if (idOf(page) case final String id) _entry(id, page),
        ]),
        Err(:final failure) => .err(failure),
      };

  DueDateModel? _date(Json page, String property) => switch (propDate(page, property)) {
    final d? => .fromEntity(d),
    null => null,
  };

  LibraryEntryModel _entry(String id, Json page) => .new(
    pageId: id,
    itemId: propText(page, P.itemId),
    title: propText(page, P.name),
    kind: propSelect(page, P.kind) == NotionValues.task ? .task : .note,
    groupId: propRelation(page, P.group).firstOrNull,
    captureId: propRelation(page, P.capture).firstOrNull,
    due: _date(page, P.due),
    reminder: _date(page, P.reminder),
    done: propCheckbox(page, P.done),
  );

  @override
  Future<NotionResult<void>> setDone(String pageId, {required bool done}) async => doneWith(
    await _http.patch('/v1/pages/$pageId', {
      NotionKeys.properties: {
        P.done: {NotionKeys.checkbox: done},
      },
    }),
  );
}

@Riverpod(keepAlive: true)
ILibraryRemoteDatasource libraryRemoteDatasource(Ref ref) =>
    LibraryRemoteDatasource(ref.read(notionHttpServiceProvider));
