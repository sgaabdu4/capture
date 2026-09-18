import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/l10n/app_localizations.dart';

extension LibrarySyncLabel on LibraryState {
  /// "Refreshing from Notion…", "Synced with Notion: 5 minutes ago." or the
  /// never-synced note. [nowUtc] comes from the system clock.
  String syncLabel(AppLocalizations l10n, DateTime nowUtc) {
    if (refreshing) return l10n.syncRefreshing;
    return switch (refreshedAtUtc) {
      final DateTime at => l10n.syncedAgo(at.agoLabel(l10n, nowUtc)),
      null => l10n.syncNever,
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
  List<LibraryEntry> filedIn(String groupId) => [
    for (final e in this)
      if (e.groupId == groupId) e,
  ];
}

extension LibraryEntryDetail on LibraryEntry {
  /// "Tomorrow 9:00 AM · Work · Reminder", or null when there is nothing to
  /// show. [today] is the local wall-clock date.
  String? detail(AppLocalizations l10n, DateTime today, Group? group) {
    final parts = [
      if (when case final DueDate day) day.label(l10n, today),
      ?group?.name,
      if (reminder != null) l10n.reminderLabel,
    ];
    return parts.isEmpty ? null : parts.join(l10n.detailSeparator);
  }
}
