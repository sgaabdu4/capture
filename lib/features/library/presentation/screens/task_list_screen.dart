import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/extensions/entry_editing.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/presentation/widgets/entry_row.dart';
import 'package:capture/features/library/presentation/widgets/refresh_button.dart';
import 'package:capture/features/library/presentation/widgets/search_field.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Open tasks from the local Library mirror. To-do lists all of them and
/// searches every saved note and task by title; Upcoming lists only dated
/// ones under a heading per day, soonest first. Tapping an entry edits it.
class TaskListScreen extends ConsumerWidget {
  const TaskListScreen.todo({super.key}) : _byDay = false;
  const TaskListScreen.upcoming({super.key}) : _byDay = true;

  final bool _byDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nowUtc = ref.watch(systemDatasourceProvider.select((s) => s.nowUtc()));
    final today = nowUtc.toLocal();
    final query = ref.watch(libraryProvider.select((s) => _byDay ? '' : s.query));
    final searching = query.trim().isNotEmpty;
    final Map<DueDate?, List<LibraryEntry>> sections = ref.watch(
      libraryProvider.select(
        (s) => switch (_byDay) {
          true => s.upcomingByDay,
          false when searching => {
            if (s.matches() case final found when found.isNotEmpty) null: found,
          },
          false => {if (s.openTasks.isNotEmpty) null: s.openTasks},
        },
      ),
    );
    final sync = ref.watch(libraryProvider.select((s) => s.syncLabel(l10n, nowUtc)));
    final refreshing = ref.watch(libraryProvider.select((s) => s.refreshing));
    final connected = ref.watch(settingsProvider.select((s) => s.notionConnected));
    final groupById = ref.watch(groupsProvider.select((s) => s.byId));
    return PageFrame(
      title: _byDay ? l10n.navUpcoming : l10n.navTodo,
      subtitle: sync,
      actions: [
        RefreshButton(
          onPressed: connected && !refreshing
              ? () => unawaited(ref.read(libraryProvider.notifier).refresh())
              : null,
        ),
      ],
      children: [
        if (!_byDay)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: SearchField(
              query: query,
              onChanged: (query) => ref.read(libraryProvider.notifier).search(query),
            ),
          ),
        if (sections.isEmpty)
          EmptyNote(switch (_byDay) {
            true => l10n.emptyUpcoming,
            false when searching => l10n.searchNoMatches(query.trim()),
            false => l10n.emptyOpenTasks,
          }),
        for (final MapEntry(key: day, value: entries) in sections.entries) ...[
          if (day != null)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.xs),
              child: Text(day.label(l10n, today), style: context.textTheme.titleMedium),
            ),
          for (final entry in entries)
            EntryRow(
              entry: entry,
              onOpen: () => unawaited(ref.editEntry(context, entry)),
              detail: entry.detail(l10n, today, groupById(entry.groupId)),
              onChanged: (done) =>
                  unawaited(ref.read(libraryProvider.notifier).setDone(entry, done: done)),
            ),
        ],
      ],
    );
  }
}
