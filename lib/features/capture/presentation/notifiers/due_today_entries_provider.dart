import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'due_today_entries_provider.g.dart';

/// An open task with the date it is due or reminds.
typedef DueEntry = ({LibraryEntry entry, DueDate due});

const _limit = 3;

/// The first few open tasks due today or earlier, soonest first, for Home's
/// Today card.
@riverpod
List<DueEntry> dueTodayEntries(Ref ref) {
  final now = ref.watch(systemDatasourceProvider).nowUtc().toLocal();
  final today = DueDate(now.year, now.month, now.day).iso;
  return [
    for (final entry in ref.watch(libraryProvider).upcoming)
      if (entry.when case final DueDate due when due.dateOnly.iso.compareTo(today) <= 0)
        (entry: entry, due: due),
  ].take(_limit).toList();
}
