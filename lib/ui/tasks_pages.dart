import 'package:flutter/material.dart';

import '../app/app_model.dart';
import '../domain/capture.dart';
import '../domain/dates/format.dart';
import 'theme.dart';
import 'widgets.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.library,
    builder: (context, _) => PageFrame(
      title: 'To-Do',
      subtitle: _synced(model),
      actions: [_RefreshButton(model: model)],
      children: [
        if (model.library.openTasks.isEmpty) const EmptyNote('No open tasks.'),
        for (final e in model.library.openTasks)
          _TaskRow(model: model, entry: e),
      ],
    ),
  );
}

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.library,
    builder: (context, _) {
      final now = model.env.now();
      final byDay = <String, List<LibraryEntry>>{};
      for (final e in model.library.upcoming) {
        final when = (e.reminder ?? e.due)!;
        byDay.putIfAbsent(formatDue(when.dateOnly, now), () => []).add(e);
      }
      return PageFrame(
        title: 'Upcoming',
        subtitle: _synced(model),
        actions: [_RefreshButton(model: model)],
        children: [
          if (byDay.isEmpty) const EmptyNote('Nothing scheduled.'),
          for (final MapEntry(key: day, value: entries) in byDay.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(day, style: Styles.cardTitle),
            ),
            for (final e in entries) _TaskRow(model: model, entry: e),
          ],
        ],
      );
    },
  );
}

String _synced(AppModel model) {
  final l = model.library;
  if (l.error != null) return l.error!;
  if (l.refreshing) return 'Refreshing from Notion…';
  if (l.refreshedAt == null) return 'From your last sync with Notion.';
  return 'Synced with Notion ${formatAgo(l.refreshedAt!, model.env.now()).toLowerCase()}.';
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) => LinkButton(
    'Refresh',
    icon: Icons.refresh,
    onPressed: model.library.refreshing || !model.settings.notionConnected
        ? null
        : model.library.refresh,
  );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.model, required this.entry});
  final AppModel model;
  final LibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    final group = model.settings.groups
        .where((g) => g.id == entry.groupId)
        .firstOrNull;
    final when = entry.reminder ?? entry.due;
    final detail = [
      if (when != null) formatDue(when, model.env.now()),
      ?group?.name,
      if (entry.reminder != null) 'Reminder',
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PaperCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Checkbox(
              value: entry.done,
              onChanged: (v) async {
                final error = await model.library.setDone(entry, v ?? false);
                if (error != null && context.mounted) {
                  showNotice(context, error);
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title, style: Styles.body),
                  if (detail.isNotEmpty) Text(detail, style: Styles.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
