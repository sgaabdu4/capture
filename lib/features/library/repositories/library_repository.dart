import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/data/system/zone_offsets.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/library/data/datasources/library_local_datasource.dart';
import 'package:capture/features/library/data/datasources/library_remote_datasource.dart';
import 'package:capture/features/library/data/models/library_entry_model.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'library_repository.g.dart';

/// Saved notes and tasks. Notion is the source of truth; the local mirror
/// keeps To-do and Upcoming useful offline.
abstract interface class ILibraryRepository {
  List<LibraryEntry> cached();
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws);

  /// Marks the task done in Notion, then locally; cancels its reminder.
  Future<NotionResult<LibraryEntry>> setDone(LibraryEntry entry, {required bool done});

  /// The body text on the entry's Notion page.
  Future<NotionResult<String>> body(LibraryEntry entry);

  /// Writes [entry] (and [body] when given) to Notion, then locally, and
  /// reschedules its reminder in the Mac's current time zone.
  Future<NotionResult<LibraryEntry>> update(LibraryEntry entry, {String? body});

  /// Moves the entry's page to Notion's trash, drops it locally and cancels
  /// its reminder.
  Future<NotionResult<void>> delete(LibraryEntry entry);
}

class LibraryRepository implements ILibraryRepository {
  LibraryRepository(this._remote, this._local, this._reminders, this._system);
  final ILibraryRemoteDatasource _remote;
  final ILibraryLocalDatasource _local;
  final IReminderDatasource _reminders;
  final ISystemDatasource _system;

  @override
  List<LibraryEntry> cached() => [for (final m in _local.all()) m.toEntity()];

  @override
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws) async {
    switch (await _remote.fetch(ws.library)) {
      case Ok(:final value):
        _local.replaceAll(value);
        return .ok([for (final m in value) m.toEntity()]);
      case Err(:final failure):
        return .err(failure);
    }
  }

  @override
  Future<NotionResult<LibraryEntry>> setDone(LibraryEntry entry, {required bool done}) async {
    final LibraryEntry(:pageId, :itemId, :copyWith) = entry;
    if (await _remote.setDone(pageId, done: done) case Err(:final failure)) {
      return .err(failure);
    }
    final updated = copyWith(done: done);
    _local.put(.fromEntity(updated));
    if (done) await _reminders.cancel(itemId);
    return .ok(updated);
  }

  @override
  Future<NotionResult<String>> body(LibraryEntry entry) async =>
      switch (await _remote.body(entry.pageId)) {
        Ok(:final value) => .ok(value.text),
        Err(:final failure) => .err(failure),
      };

  @override
  Future<NotionResult<LibraryEntry>> update(LibraryEntry entry, {String? body}) async {
    final timeZone = await _system.timeZone();
    final model = LibraryEntryModel.fromEntity(entry);
    if (await _remote.update(model, timeZone: timeZone) case Err(:final failure)) {
      return .err(failure);
    }
    if (body != null) {
      switch (await _remote.body(entry.pageId)) {
        case Err(:final failure):
          return .err(failure);
        case Ok(:final value) when value.text != body:
          if (await _remote.replaceBody(entry.pageId, value, body) case Err(:final failure)) {
            return .err(failure);
          }
        case Ok():
      }
    }
    _local.put(model);
    await _reminders.cancel(entry.itemId);
    await _remind(entry, timeZone);
    return .ok(entry);
  }

  /// Schedules the reminder of an open task when it is still ahead.
  Future<void> _remind(LibraryEntry entry, String timeZone) async {
    final at = switch (entry) {
      LibraryEntry(kind: .task, done: false, :final reminder?) => reminderInstant(
        reminder,
        zoneOffsets(timeZone),
      ),
      _ => null,
    };
    if (at == null || !at.isAfter(_system.nowUtc())) return;
    await _reminders.schedule(
      itemId: entry.itemId,
      title: entry.title,
      at: .from(at, tz.getLocation(timeZone)),
    );
  }

  @override
  Future<NotionResult<void>> delete(LibraryEntry entry) async {
    if (await _remote.trash(entry.pageId) case Err(:final failure)) return .err(failure);
    _local.remove(entry.itemId);
    await _reminders.cancel(entry.itemId);
    return const .ok(null);
  }
}

@Riverpod(keepAlive: true)
ILibraryRepository libraryRepository(Ref ref) => LibraryRepository(
  ref.read(libraryRemoteDatasourceProvider),
  ref.read(libraryLocalDatasourceProvider),
  ref.read(reminderDatasourceProvider),
  ref.read(systemDatasourceProvider),
);
