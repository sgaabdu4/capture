import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/l10n/app_localizations.g.dart';

extension LibrarySyncLabel on LibraryState {
  /// The sync line: refreshing or "Synced with Notion: 5 minutes ago."; null before the first refresh.
  String? syncLabel(AppLocalizations l10n, DateTime nowUtc) {
    if (refreshing) return l10n.syncRefreshing;
    return switch (refreshedAtUtc) {
      final DateTime at => l10n.syncedAgo(at.agoLabel(l10n, nowUtc)),
      null => null,
    };
  }

  /// [upcoming] keyed by its (reminder or due) day, soonest first.
  Map<DueDate, List<LibraryEntry>> get upcomingByDay {
    final byDay = <DueDate, List<LibraryEntry>>{};
    for (final entry in upcoming) {
      if (entry.when case final DueDate day) {
        byDay.putIfAbsent(day.dateOnly, () => []).add(entry);
      }
    }
    return byDay;
  }
}

extension LibraryEntriesInGroup on Iterable<LibraryEntry> {
  /// Entries filed in the group with [groupId].
  List<LibraryEntry> filedIn(NotionId groupId) => [
    for (final e in this)
      if (e.groupId == groupId) e,
  ];
}

extension LibraryEntryDetail on LibraryEntry {
  /// "Tomorrow 9:00 AM · Work · Reminder", or null when empty; [today] is the local wall-clock date.
  /// With [underDay] the day heading above already says the day, so only the time shows.
  String? detail(AppLocalizations l10n, DateTime today, Group? group, {bool underDay = false}) {
    final parts = [
      if (when case final DueDate day)
        if (underDay) ?day.timeLabel(l10n) else day.label(l10n, today),
      ?group?.name,
      if (reminder != null) l10n.reminderLabel,
    ];
    return parts.isEmpty ? null : parts.join(l10n.detailSeparator);
  }
}
