import 'dart:io';

import 'package:timezone/timezone.dart' as tz;

import '../domain/capture.dart';
import '../domain/models.dart';
import 'notion_client.dart';
import 'notion_shapes.dart';
import 'notion_workspace.dart';

enum SaveStep { capture, items, audio, finish }

class SaveFailure implements Exception {
  const SaveFailure(this.step, this.message, {this.transient = true});
  final SaveStep step;
  final String message;
  final bool transient;

  @override
  String toString() => 'SaveFailure($step)';
}

/// Saves an approved capture to Notion one confirmed step at a time:
/// capture page → library items → audio → mark Saved. After every step
/// [persist] stores the new [SaveProgress] before the next begins. A retry
/// skips confirmed steps and, for any step whose result is unknown (e.g. a
/// timeout after the request was sent), looks up the stable Capture ID /
/// Item ID first, so nothing is ever created twice.
class NotionSaver {
  NotionSaver(this._client, this._workspace);
  final NotionClient _client;
  final NotionWorkspace _workspace;

  Future<CaptureRecord> save(
    CaptureRecord record, {
    required Future<void> Function(CaptureRecord, SaveStep) persist,
  }) async {
    var r = record;
    Future<void> step(SaveStep s, Future<CaptureRecord> Function() run) async {
      try {
        r = await run();
      } on NotionException catch (e) {
        throw SaveFailure(s, e.userMessage, transient: e.transient);
      } on FileSystemException {
        throw SaveFailure(s, "The recording file couldn't be read.");
      }
      await persist(r, s);
    }

    if (r.progress.capturePageId == null) {
      await step(SaveStep.capture, () => _capturePage(r));
    }
    for (final item in r.includedItems) {
      if (r.progress.itemPages.containsKey(item.id)) continue;
      await step(SaveStep.items, () => _item(r, item));
    }
    if (!r.progress.audioAttached && r.m4aPath != null) {
      await step(SaveStep.audio, () => _audio(r));
    }
    if (!r.progress.markedSaved) {
      await step(SaveStep.finish, () => _finish(r));
    }
    return r;
  }

  Future<String?> _findBy(
    String dataSource,
    String property,
    String value,
  ) async {
    final result = await _client.post('/v1/data_sources/$dataSource/query', {
      'filter': {
        'property': property,
        'rich_text': {'equals': value},
      },
      'page_size': 1,
    });
    final pages = result['results'] as List<Object?>? ?? const [];
    return pages.isEmpty
        ? null
        : (pages.first! as Map<String, Object?>)['id']! as String;
  }

  Future<CaptureRecord> _capturePage(CaptureRecord r) async {
    final id =
        await _findBy(_workspace.captures, P.captureId, r.id) ??
        (await _client.post('/v1/pages', {
              'parent': {
                'type': 'data_source_id',
                'data_source_id': _workspace.captures,
              },
              'properties': {
                P.name: titleValue(captureTitle(r)),
                P.captureId: textValue(r.id),
                P.capturedAt: {
                  'date': {'start': r.capturedAtUtc.toUtc().toIso8601String()},
                },
                P.timeZone: textValue(r.timeZone),
                P.duration: {'number': (r.durationSeconds * 10).round() / 10},
                P.status: selectValue('Incomplete'),
              },
              'children': transcriptBlocks(r.transcript ?? ''),
            }))['id']!
            as String;
    return r.copyWith(progress: r.progress.copyWith(capturePageId: id));
  }

  Future<CaptureRecord> _item(CaptureRecord r, ProposalItem item) async {
    final id =
        await _findBy(_workspace.library, P.itemId, item.id) ??
        (await _client.post('/v1/pages', {
              'parent': {
                'type': 'data_source_id',
                'data_source_id': _workspace.library,
              },
              'properties': itemProperties(r, item),
              'children': itemBlocks(item),
            }))['id']!
            as String;
    return r.copyWith(
      progress: r.progress.copyWith(
        itemPages: {...r.progress.itemPages, item.id: id},
      ),
    );
  }

  Future<CaptureRecord> _audio(CaptureRecord r) async {
    final pageId = r.progress.capturePageId!;
    final page = await _client.get('/v1/pages/$pageId');
    if (propFiles(page, P.recording).isNotEmpty) {
      return r.copyWith(progress: r.progress.copyWith(audioAttached: true));
    }
    final bytes = await File(r.m4aPath!).readAsBytes();
    if (bytes.length > _workspace.maxUploadBytes) {
      throw const SaveFailure(
        SaveStep.audio,
        'The recording is larger than this Notion workspace allows.',
        transient: false,
      );
    }
    final name = 'capture-${r.id}.m4a';
    final upload = await _client.uploadFile(
      bytes,
      filename: name,
      contentType: 'audio/mp4',
    );
    await _client.patch('/v1/pages/$pageId', {
      'properties': {
        P.recording: {
          'files': [
            {
              'type': 'file_upload',
              'file_upload': {'id': upload},
              'name': name,
            },
          ],
        },
      },
    });
    return r.copyWith(
      progress: r.progress.copyWith(audioUploadId: upload, audioAttached: true),
    );
  }

  Future<CaptureRecord> _finish(CaptureRecord r) async {
    await _client.patch('/v1/pages/${r.progress.capturePageId}', {
      'properties': {P.status: selectValue('Saved')},
    });
    return r.copyWith(progress: r.progress.copyWith(markedSaved: true));
  }

  Map<String, Object?> itemProperties(CaptureRecord r, ProposalItem item) => {
    P.name: titleValue(item.title),
    P.itemId: textValue(item.id),
    P.kind: selectValue(item.kind == ItemKind.task ? 'Task' : 'Note'),
    P.group: relationValue([?item.groupId]),
    P.capture: relationValue([r.progress.capturePageId!]),
    P.done: {'checkbox': false},
    P.due: dateValue(item.kind == ItemKind.task ? item.due : null, r.timeZone),
    P.reminder: dateValue(
      item.kind == ItemKind.task ? item.reminder : null,
      r.timeZone,
    ),
  };
}

/// "18 Sep 2026, 09:30" in the capture's own time zone.
String captureTitle(CaptureRecord r) {
  final local = tz.TZDateTime.from(r.capturedAtUtc, tz.getLocation(r.timeZone));
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  String two(int v) => v.toString().padLeft(2, '0');
  return 'Capture ${local.day} ${months[local.month - 1]} ${local.year}, '
      '${two(local.hour)}:${two(local.minute)}';
}

List<Map<String, Object?>> transcriptBlocks(String transcript) => [
  block('heading_2', 'Transcript'),
  ...paragraphs(transcript),
].take(maxChildren).toList();

List<Map<String, Object?>> itemBlocks(ProposalItem item) => [
  if (item.body.trim().isNotEmpty) ...paragraphs(item.body),
  for (final s in item.sources) block('quote', s.excerpt),
].take(maxChildren).toList();
