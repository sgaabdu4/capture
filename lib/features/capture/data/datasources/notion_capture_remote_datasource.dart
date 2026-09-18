import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/data/notion/notion_query.dart';
import 'package:capture/core/data/notion/notion_schema.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notion_capture_remote_datasource.g.dart';

/// The individual, idempotent Notion writes of an approved save. Each
/// `find*` looks up the stable Capture ID / Item ID so a retry after an
/// unknown outcome (e.g. a timeout after the request was sent) never
/// creates a second page.
abstract interface class INotionCaptureRemoteDatasource {
  Future<NotionResult<String?>> findCapturePage(NotionWorkspace ws, String captureId);
  Future<NotionResult<String>> createCapturePage(NotionWorkspace ws, CaptureRecord record);
  Future<NotionResult<String?>> findItemPage(NotionWorkspace ws, String itemId);
  Future<NotionResult<String>> createItemPage(
    NotionWorkspace ws,
    CaptureRecord record,
    ProposalItem item, {
    required String capturePageId,
  });
  Future<NotionResult<bool>> hasRecording(String capturePageId);

  /// Uploads and attaches the M4A; returns the upload id.
  Future<NotionResult<String>> attachRecording(
    String capturePageId,
    List<int> bytes, {
    required String name,
  });
  Future<NotionResult<void>> markSaved(String capturePageId);
}

class NotionCaptureRemoteDatasource implements INotionCaptureRemoteDatasource {
  NotionCaptureRemoteDatasource(this._http);
  final INotionHttpService _http;

  /// M4A recordings are uploaded as `audio/mp4`.
  static const _m4aSubtype = 'mp4';
  static final _audioType = MediaType(NotionKeys.audio, _m4aSubtype);

  /// Seconds are stored to one decimal place.
  static const _durationScale = 10;

  Future<NotionResult<String?>> _findBy(String dataSource, String property, String value) async =>
      switch (await _http.post('/v1/data_sources/$dataSource/query', {
        NotionKeys.filter: {
          NotionKeys.property: property,
          NotionKeys.richText: {NotionKeys.equals: value},
        },
        NotionKeys.pageSize: 1,
      })) {
        Ok(value: {'results': [final Json first, ...]}) => .ok(idOf(first)),
        Ok() => const .ok(null),
        Err(:final failure) => .err(failure),
      };

  Future<NotionResult<String>> _create(Json body) async =>
      createdId(await _http.post('/v1/pages', body));

  @override
  Future<NotionResult<String?>> findCapturePage(NotionWorkspace ws, String captureId) =>
      _findBy(ws.captures, P.captureId, captureId);

  @override
  Future<NotionResult<String>> createCapturePage(NotionWorkspace ws, CaptureRecord r) => _create({
    NotionKeys.parent: {NotionKeys.type: 'data_source_id', NotionKeys.dataSourceId: ws.captures},
    NotionKeys.properties: {
      P.name: titleValue(captureTitle(r)),
      P.captureId: textValue(r.id),
      P.capturedAt: {
        NotionKeys.date: {NotionKeys.start: r.capturedAtUtc.toUtc().toIso8601String()},
      },
      P.timeZone: textValue(r.timeZone),
      P.duration: {
        NotionKeys.number:
            (r.duration.inMilliseconds * _durationScale / Duration.millisecondsPerSecond).round() /
            _durationScale,
      },
      P.status: selectValue(NotionValues.incomplete),
    },
    NotionKeys.children: transcriptBlocks(r.transcript ?? ''),
  });

  @override
  Future<NotionResult<String?>> findItemPage(NotionWorkspace ws, String itemId) =>
      _findBy(ws.library, P.itemId, itemId);

  @override
  Future<NotionResult<String>> createItemPage(
    NotionWorkspace ws,
    CaptureRecord r,
    ProposalItem item, {
    required String capturePageId,
  }) => _create({
    NotionKeys.parent: {NotionKeys.type: 'data_source_id', NotionKeys.dataSourceId: ws.library},
    NotionKeys.properties: {
      P.name: titleValue(item.title),
      P.itemId: textValue(item.id),
      P.kind: selectValue(item.isTask ? NotionValues.task : NotionValues.note),
      P.group: relationValue([?item.groupId]),
      P.capture: relationValue([capturePageId]),
      P.done: {NotionKeys.checkbox: false},
      P.due: dateValue(item.isTask ? item.due : null, r.timeZone),
      P.reminder: dateValue(item.isTask ? item.reminder : null, r.timeZone),
    },
    NotionKeys.children: itemBlocks(item),
  });

  @override
  Future<NotionResult<bool>> hasRecording(String capturePageId) async =>
      switch (await _http.get('/v1/pages/$capturePageId')) {
        Ok(:final value) => .ok(propFiles(value, P.recording).isNotEmpty),
        Err(:final failure) => .err(failure),
      };

  @override
  Future<NotionResult<String>> attachRecording(
    String capturePageId,
    List<int> bytes, {
    required String name,
  }) async {
    final String upload;
    switch (await _http.uploadFile(bytes, filename: name, type: _audioType)) {
      case Ok(:final value):
        upload = value;
      case Err(:final failure):
        return .err(failure);
    }
    final attached = await _http.patch('/v1/pages/$capturePageId', {
      NotionKeys.properties: {
        P.recording: {
          NotionKeys.files: [
            {
              NotionKeys.type: 'file_upload',
              NotionKeys.fileUpload: {NotionKeys.id: upload},
              NotionKeys.name: name,
            },
          ],
        },
      },
    });
    return switch (attached) {
      Ok() => .ok(upload),
      Err(:final failure) => .err(failure),
    };
  }

  @override
  Future<NotionResult<void>> markSaved(String capturePageId) async => doneWith(
    await _http.patch('/v1/pages/$capturePageId', {
      NotionKeys.properties: {P.status: selectValue(NotionValues.saved)},
    }),
  );
}

/// "Capture 18 Sep 2026, 09:30" in the capture's own time zone.
String captureTitle(CaptureRecord r) =>
    captureTitleFormat.format(tz.TZDateTime.from(r.capturedAtUtc, tz.getLocation(r.timeZone)));

List<Json> transcriptBlocks(String transcript) =>
    [block('heading_2', 'Transcript'), ...paragraphs(transcript)].take(maxChildren).toList();

List<Json> itemBlocks(ProposalItem item) => [
  if (item.body.trim().isNotEmpty) ...paragraphs(item.body),
  for (final s in item.sources) block('quote', s.excerpt),
].take(maxChildren).toList();

@Riverpod(keepAlive: true)
INotionCaptureRemoteDatasource notionCaptureRemoteDatasource(Ref ref) =>
    NotionCaptureRemoteDatasource(ref.read(notionHttpServiceProvider));
