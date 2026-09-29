import 'package:capture/core/crash/crash.dart';
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

  void _markRefreshing() => state = state.copyWith(refreshing: true, cacheRefreshFailed: false);

  Future<void> refresh() async {
    final ws = ref.read(settingsProvider).workspace;
    if (ws == null || state.refreshing) return;
    final repository = _ensureRepository();
    _markRefreshing();
    try {
      final result = await repository.refresh(ws);
      if (!ref.mounted) return;
      state = switch (result) {
        Ok(:final value) => state.copyWith(
          refreshing: false,
          entries: value,
          refreshedAtUtc: ref.read(systemDatasourceProvider).nowUtc(),
        ),
        Err(:final failure) => _failed(state.copyWith(refreshing: false), failure),
      };
    } on Exception catch (error, stackTrace) {
      Crash.error(error, stackTrace);
      if (!ref.mounted) return;
      state = state.copyWith(
        refreshing: false,
        cacheRefreshFailed: true,
        failure: null,
        failureSerial: state.failureSerial + 1,
      );
    }
  }

  Future<void> setDone(LibraryEntry entry, {required bool done}) async {
    try {
      final result = await _ensureRepository().setDone(entry, done: done);
      if (!ref.mounted) return;
      state = _replaced(result);
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  /// Prepares one editor snapshot; a later request owns any subsequent completion.
  Future<void> body(LibraryEntry entry, {required String origin}) async {
    final serial = state.bodyLoadSerial + 1;
    state = state.copyWith(
      bodyEntry: entry,
      bodyOrigin: origin,
      bodyLoading: true,
      bodyText: null,
      bodyLoadSerial: serial,
    );
    try {
      final result = await _ensureRepository().body(entry);
      if (!ref.mounted) return;
      if (state.bodyLoadSerial != serial) return;
      state = switch (result) {
        Ok(:final value) => state.copyWith(bodyLoading: false, bodyText: value),
        Err(:final failure) => _failed(state.copyWith(bodyLoading: false), failure),
      };
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
      if (!ref.mounted) return;
      if (state.bodyLoadSerial != serial) return;
      state = state.copyWith(bodyLoading: false);
    }
  }

  /// Saves an edited entry; [body] only when it should be rewritten.
  Future<void> update(LibraryEntry entry, {String? body}) async {
    try {
      final result = await _ensureRepository().update(entry, body: body);
      if (!ref.mounted) return;
      state = _replaced(result);
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  Future<void> delete(LibraryEntry entry) async {
    try {
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
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  void search(String query) => state = state.copyWith(query: query);

  /// The saved entry in place of the one with its id, or the failure.
  LibraryState _replaced(NotionResult<LibraryEntry> result) => switch (result) {
    Ok(:final value) => state.copyWith(
      entries: [for (final e in state.entries) e.itemId == value.itemId ? value : e],
    ),
    Err(:final failure) => _failed(state, failure),
  };

  static LibraryState _failed(LibraryState s, NotionFailure failure) =>
      s.copyWith(failure: failure, cacheRefreshFailed: false, failureSerial: s.failureSerial + 1);
}
