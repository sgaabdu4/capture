import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_state.freezed.dart';

/// Local mirror of the Notion Library for To-do and Upcoming. Notion is the
/// source of truth; the cache keeps the views useful offline.
@freezed
sealed class LibraryState with _$LibraryState {
  const LibraryState._();

  const factory LibraryState({
    required List<LibraryEntry> entries,
    @Default(false) bool refreshing,
    NotionFailure? failure,
    @Default(0) int failureSerial,
    DateTime? refreshedAtUtc,

    /// Text typed into search; empty when not searching.
    @Default('') String query,
  }) = _LibraryState;

  bool get searching => query.trim().isNotEmpty;

  /// Saved notes and tasks whose title contains [query], ignoring case,
  /// newest first as Notion returns them.
  List<LibraryEntry> matches() {
    final needle = query.trim().toLowerCase();
    return [
      for (final e in entries)
        if (needle.isNotEmpty && e.title.toLowerCase().contains(needle)) e,
    ];
  }

  /// Open tasks, dated ones soonest first.
  List<LibraryEntry> get openTasks => [
    for (final e in entries)
      if (e.kind == .task && !e.done) e,
  ]..sort(_byWhen);

  /// Open tasks with a date, soonest first.
  List<LibraryEntry> get upcoming => [
    for (final e in openTasks)
      if (e.when != null) e,
  ];

  static int _byWhen(LibraryEntry a, LibraryEntry b) => switch ((x: a.when?.iso, y: b.when?.iso)) {
    (x: final String x, y: final String y) => x.compareTo(y),
    (x: String(), y: null) => -1,
    (x: null, y: String()) => 1,
    (x: null, y: null) => a.title.compareTo(b.title),
  };
}
