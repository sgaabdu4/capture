import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_notifier.g.dart';

@Riverpod(keepAlive: true)
class LibraryNotifier extends _$LibraryNotifier {
  @override
  LibraryState build() => .new(entries: ref.read(libraryRepositoryProvider).cached());

  ILibraryRepository _ensureRepository() => ref.read(libraryRepositoryProvider);

  void _markRefreshing() => state = state.copyWith(refreshing: true);

  Future<void> refresh() async {
    final ws = ref.read(settingsProvider).workspace;
    if (ws == null || state.refreshing) return;
    _markRefreshing();
    final result = await _ensureRepository().refresh(ws);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => state.copyWith(
        refreshing: false,
        entries: value,
        refreshedAtUtc: ref.read(systemDatasourceProvider).nowUtc(),
      ),
      Err(:final failure) => _failed(state.copyWith(refreshing: false), failure),
    };
  }

  Future<void> setDone(LibraryEntry entry, {required bool done}) async {
    final result = await _ensureRepository().setDone(entry, done: done);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => state.copyWith(
        entries: [for (final e in state.entries) e.itemId == value.itemId ? value : e],
      ),
      Err(:final failure) => _failed(state, failure),
    };
  }

  /// The body on the entry's Notion page, or null when it cannot be read.
  Future<String?> body(LibraryEntry entry) async {
    final result = await _ensureRepository().body(entry);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        return value;
      case Err(:final failure):
        state = _failed(state, failure);
        return null;
    }
  }

  /// Saves an edited entry; [body] only when it should be rewritten.
  Future<void> update(LibraryEntry entry, {String? body}) async {
    final result = await _ensureRepository().update(entry, body: body);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => state.copyWith(
        entries: [for (final e in state.entries) e.itemId == value.itemId ? value : e],
      ),
      Err(:final failure) => _failed(state, failure),
    };
  }

  Future<void> delete(LibraryEntry entry) async {
    final result = await _ensureRepository().delete(entry);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => state.copyWith(
        entries: [
          for (final e in state.entries)
            if (e.itemId != entry.itemId) e,
        ],
      ),
      Err(:final failure) => _failed(state, failure),
    };
  }

  void search(String query) => state = state.copyWith(query: query);

  static LibraryState _failed(LibraryState s, NotionFailure failure) =>
      s.copyWith(failure: failure, failureSerial: s.failureSerial + 1);
}
