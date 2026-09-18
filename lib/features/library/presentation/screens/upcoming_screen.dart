import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/presentation/widgets/refresh_button.dart';
import 'package:capture/features/library/presentation/widgets/task_row.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dated open tasks, grouped by day, soonest first.
class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nowUtc = ref.watch(systemDatasourceProvider.select((s) => s.nowUtc()));
    final today = nowUtc.toLocal();
    final byDay = ref.watch(libraryProvider.select((s) => s.upcomingByDay));
    final sync = ref.watch(libraryProvider.select((s) => s.syncLabel(l10n, nowUtc)));
    final refreshing = ref.watch(libraryProvider.select((s) => s.refreshing));
    final connected = ref.watch(settingsProvider.select((s) => s.notionConnected));
    final groupById = ref.watch(groupsProvider.select((s) => s.byId));
    return PageFrame(
      title: l10n.navUpcoming,
      subtitle: sync,
      actions: [
        RefreshButton(
          onPressed: connected && !refreshing
              ? () => unawaited(ref.read(libraryProvider.notifier).refresh())
              : null,
        ),
      ],
      children: [
        if (byDay.isEmpty) EmptyNote(l10n.emptyUpcoming),
        for (final MapEntry(key: day, value: entries) in byDay.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.xs),
            child: Text(day.label(l10n, today), style: context.textTheme.titleMedium),
          ),
          for (final entry in entries)
            TaskRow(
              entry: entry,
              detail: entry.detail(l10n, today, groupById(entry.groupId)),
              onChanged: (done) =>
                  unawaited(ref.read(libraryProvider.notifier).setDone(entry, done: done)),
            ),
        ],
      ],
    );
  }
}
