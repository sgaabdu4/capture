import 'package:capture/app/env.dart';
import 'package:capture/app/settings_controller.dart';
import 'package:capture/features/capture/domain/entities/capture.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:flutter/foundation.dart';

/// Local mirror of the Notion Library for To-do and Upcoming. Notion is the
/// source of truth; the cache keeps the views useful offline.
class LibraryController extends ChangeNotifier {
  LibraryController(this._env, this._settings) {
    entries = _env.store.library();
  }

  final AppEnv _env;
  final SettingsController _settings;

  List<LibraryEntry> entries = const [];
  bool refreshing = false;
  String? error;
  DateTime? refreshedAt;

  List<LibraryEntry> get openTasks => [
    for (final e in entries)
      if (e.kind == ItemKind.task && !e.done) e,
  ]..sort(_byWhen);

  /// Open tasks with a date, soonest first.
  List<LibraryEntry> get upcoming => [
    for (final e in openTasks)
      if ((e.reminder ?? e.due) != null) e,
  ];

  static int _byWhen(LibraryEntry a, LibraryEntry b) {
    final x = (a.reminder ?? a.due)?.iso;
    final y = (b.reminder ?? b.due)?.iso;
    if (x == null && y == null) return a.title.compareTo(b.title);
    if (x == null) return 1;
    if (y == null) return -1;
    return x.compareTo(y);
  }

  Future<void> refresh() async {
    final ws = _settings.workspace;
    if (ws == null || refreshing) return;
    refreshing = true;
    error = null;
    notifyListeners();
    try {
      final pages = await _settings.withNotion(
        (client) => queryAll(client, ws.library, {
          'sorts': [
            {'timestamp': 'created_time', 'direction': 'descending'},
          ],
        }),
      );
      entries = [for (final p in pages) _entry(p)];
      _env.store.replaceLibrary(entries);
      refreshedAt = _env.now();
    } on NotionException catch (e) {
      error = e.userMessage;
    } finally {
      refreshing = false;
      notifyListeners();
    }
  }

  LibraryEntry _entry(Map<String, Object?> page) => LibraryEntry(
    pageId: page['id']! as String,
    itemId: propText(page, P.itemId),
    title: propText(page, P.name),
    kind: propSelect(page, P.kind) == 'Task' ? ItemKind.task : ItemKind.note,
    groupId: propRelation(page, P.group).firstOrNull,
    captureId: propRelation(page, P.capture).firstOrNull,
    due: propDate(page, P.due),
    reminder: propDate(page, P.reminder),
    done: propCheckbox(page, P.done),
  );

  Future<String?> setDone(LibraryEntry entry, bool done) async {
    try {
      await _settings.withNotion(
        (client) => client.patch('/v1/pages/${entry.pageId}', {
          'properties': {
            P.done: {'checkbox': done},
          },
        }),
      );
    } on NotionException catch (e) {
      return e.userMessage;
    }
    final updated = LibraryEntry.fromJson({...entry.toJson(), 'done': done});
    entries = [for (final e in entries) e.itemId == entry.itemId ? updated : e];
    _env.store.putLibrary(updated);
    if (done) await _env.reminders.cancel(entry.itemId);
    notifyListeners();
    return null;
  }
}
