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

/// The body the app wrote on an item page: the text of its leading
/// paragraph blocks and their ids.
typedef ItemBody = ({String text, List<String> blockIds});

/// One paragraph block: its id and plain text.
typedef _Paragraph = ({String id, String text});

/// The Library data source in Notion (source of truth for saved items).
abstract interface class ILibraryRemoteDatasource {
  Future<NotionResult<List<LibraryEntryModel>>> fetch(String dataSource);
  Future<NotionResult<void>> setDone(String pageId, {required bool done});

  /// Writes title, group, due and reminder; timed dates carry [timeZone].
  Future<NotionResult<void>> update(LibraryEntryModel entry, {required String timeZone});

  /// The leading paragraphs of the page; quotes and later blocks are not body.
  Future<NotionResult<ItemBody>> body(String pageId);

  /// Replaces [old] with [text] at the top of the page, leaving every other
  /// block in place.
  Future<NotionResult<void>> replaceBody(String pageId, ItemBody old, String text);

  /// Moves the page to Notion's trash, where it can be restored.
  Future<NotionResult<void>> trash(String pageId);
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

  @override
  Future<NotionResult<void>> update(LibraryEntryModel entry, {required String timeZone}) async {
    final LibraryEntryModel(:pageId, :title, :groupId, :due, :reminder) = entry;
    return doneWith(
      await _http.patch('/v1/pages/$pageId', {
        NotionKeys.properties: {
          P.name: titleValue(title),
          P.group: relationValue([?groupId]),
          P.due: dateValue(due?.toEntity(), timeZone),
          P.reminder: dateValue(reminder?.toEntity(), timeZone),
        },
      }),
    );
  }

  @override
  Future<NotionResult<ItemBody>> body(String pageId) async {
    switch (await childrenOf(_http, pageId)) {
      case Err(:final failure):
        return .err(failure);
      case Ok(:final value):
        final leading = value.map(_paragraphOf).takeWhile((p) => p != null).nonNulls.toList();
        return .ok((
          text: leading.map((p) => p.text).join(_paragraphBreak),
          blockIds: [for (final p in leading) p.id],
        ));
    }
  }

  @override
  Future<NotionResult<void>> replaceBody(String pageId, ItemBody old, String text) async {
    for (final id in old.blockIds) {
      if (await _http.patch('/v1/blocks/$id', {NotionKeys.inTrash: true}) case Err(
        :final failure,
      )) {
        return .err(failure);
      }
    }
    final blocks = paragraphs(text).take(maxChildren).toList();
    if (blocks.isEmpty) return const .ok(null);
    return doneWith(
      await _http.patch('/v1/blocks/$pageId/children', {
        NotionKeys.children: blocks,
        NotionKeys.position: {NotionKeys.type: NotionKeys.start},
      }),
    );
  }

  @override
  Future<NotionResult<void>> trash(String pageId) async =>
      doneWith(await _http.patch('/v1/pages/$pageId', {NotionKeys.inTrash: true}));

  static const _paragraph = 'paragraph';

  static _Paragraph? _paragraphOf(Json block) => switch (block) {
    {
      NotionKeys.type: _paragraph,
      NotionKeys.id: final String id,
      _paragraph: {NotionKeys.richText: final Object? text},
    } =>
      (id: id, text: plainText(text)),
    _ => null,
  };

  /// Paragraphs read back as lines, so a saved body round-trips.
  static const _paragraphBreak = '\n';
}

@Riverpod(keepAlive: true)
ILibraryRemoteDatasource libraryRemoteDatasource(Ref ref) =>
    LibraryRemoteDatasource(ref.read(notionHttpServiceProvider));
