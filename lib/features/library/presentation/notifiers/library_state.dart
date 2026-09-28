import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_state.freezed.dart';

/// An open task with the date it is due or reminds.
typedef DueEntry = ({LibraryEntry entry, DueDate due});

/// Notion remains the source of truth; its local mirror keeps views useful offline.
@freezed
sealed class LibraryState with _$LibraryState {
  const LibraryState._();

  static const _todayLimit = 3;

  const factory LibraryState({
    required List<LibraryEntry> entries,
    @Default(false) bool refreshing,
    @Default(false) bool cacheRefreshFailed,
    NotionFailure? failure,
    @Default(0) int failureSerial,
    DateTime? refreshedAtUtc,

    /// Text typed into search; empty when not searching.
    @Default('') String query,
  }) = _LibraryState;

  bool get searching => query.trim().isNotEmpty;

  List<LibraryEntry> matches() {
    final needle = query.trim().toLowerCase();
    return [
      for (final e in entries)
        if (e.title case final String title)
          if (needle.isNotEmpty && title.toLowerCase().contains(needle)) e,
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

  /// The first open tasks due by the local calendar day in [now].
  List<DueEntry> dueToday(DateTime now) {
    final today = DueDate(now.year, now.month, now.day).iso;
    return [
      for (final entry in upcoming)
        if (entry.when case final DueDate due when due.dateOnly.iso.compareTo(today) <= 0)
          (entry: entry, due: due),
    ].take(_todayLimit).toList();
  }

  static int _byWhen(LibraryEntry a, LibraryEntry b) => switch ((x: a.when?.iso, y: b.when?.iso)) {
    (x: final String x, y: final String y) => x.compareTo(y),
    (x: String(), y: null) => -1,
    (x: null, y: String()) => 1,
    (x: null, y: null) => _byTitle(a.title, b.title),
  };

  /// Untitled entries sort first, as blank titles did.
  static int _byTitle(String? a, String? b) => switch ((x: a, y: b)) {
    (x: final String x, y: final String y) => x.compareTo(y),
    (x: null, y: String()) => -1,
    (x: String(), y: null) => 1,
    (x: null, y: null) => 0,
  };
}
