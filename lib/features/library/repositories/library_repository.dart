import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/library/data/datasources/library_local_datasource.dart';
import 'package:capture/features/library/data/datasources/library_remote_datasource.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_repository.g.dart';

/// Saved notes and tasks. Notion is the source of truth; the local mirror
/// keeps To-do and Upcoming useful offline.
abstract interface class ILibraryRepository {
  List<LibraryEntry> cached();
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws);

  /// Marks the task done in Notion, then locally; cancels its reminder.
  Future<NotionResult<LibraryEntry>> setDone(LibraryEntry entry, {required bool done});
}

class LibraryRepository implements ILibraryRepository {
  LibraryRepository(this._remote, this._local, this._reminders);
  final ILibraryRemoteDatasource _remote;
  final ILibraryLocalDatasource _local;
  final IReminderDatasource _reminders;

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
}

@Riverpod(keepAlive: true)
ILibraryRepository libraryRepository(Ref ref) => LibraryRepository(
  ref.read(libraryRemoteDatasourceProvider),
  ref.read(libraryLocalDatasourceProvider),
  ref.read(reminderDatasourceProvider),
);
