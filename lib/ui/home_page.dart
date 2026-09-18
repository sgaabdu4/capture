import 'package:capture/app/app_model.dart';
import 'package:capture/app/capture_flow.dart';
import 'package:capture/features/capture/domain/entities/capture.dart';
import 'package:capture/core/extensions/date_format.dart';
import 'package:capture/ui/setup_panel.dart';
import 'package:capture/ui/theme.dart';
import 'package:capture/ui/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([model.flow, model.settings, model.library]),
    builder: (context, _) {
      final ready = model.settings.ready;
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(36, 72, 36, 36),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 108),
            child: Column(
              children: [
                const Underlined('Capture', style: Styles.hero),
                const SizedBox(height: 18),
                const Text("Say anything. We'll sort it.", style: Styles.tagline),
                const SizedBox(height: 44),
                _Recorder(model: model, ready: ready),
                if (model.flow.notice != null) ...[
                  const SizedBox(height: 14),
                  Text(model.flow.notice!, style: Styles.label, textAlign: TextAlign.center),
                ],
                const SizedBox(height: 44),
                if (ready) _Cards(model: model) else SetupPanel(model: model),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _Recorder extends StatelessWidget {
  const _Recorder({required this.model, required this.ready});
  final AppModel model;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    final phase = model.flow.phase;
    final recording = phase == Phase.recording;
    final busy = phase != Phase.idle && !recording;
    final label = switch (phase) {
      Phase.idle => 'Tap to record',
      Phase.recording => 'Tap to stop',
      Phase.transcribing => 'Transcribing…',
      Phase.analysing => 'Sorting…',
      Phase.review => 'Waiting for your review',
      Phase.saving => 'Saving to Notion…',
    };
    return Column(
      children: [
        MicButton(recording: recording, onPressed: ready && !busy ? model.flow.toggle : null),
        const SizedBox(height: 22),
        Text(label, style: Styles.body.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text('or press ${model.settings.shortcut.label}', style: Styles.label),
      ],
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 1080),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _TodayCard(model: model)),
          const SizedBox(width: 20),
          Expanded(child: _RecentCard(model: model)),
          const SizedBox(width: 20),
          Expanded(child: _GroupsCard(model: model)),
        ],
      ),
    ),
  );
}

class _CardHeader extends StatelessWidget {
  const _CardHeader(this.title, {this.onViewAll});
  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Align(alignment: Alignment.centerLeft, child: Underlined(title)),
      ),
      if (onViewAll != null)
        LinkButton('View all', onPressed: onViewAll, icon: Icons.chevron_right),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.leading, required this.title, required this.subtitle, this.onTap});
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Styles.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: Styles.label),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) {
    final now = model.env.now();
    final today = [
      for (final e in model.library.upcoming)
        if ((e.reminder ?? e.due)!.iso.compareTo(_endOfToday(now)) <= 0) e,
    ].take(3).toList();
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader('Today', onViewAll: () => model.section.value = Section.todo),
          const SizedBox(height: 10),
          if (today.isEmpty) const EmptyNote('Nothing due today.'),
          for (final e in today)
            _Row(
              leading: Checkbox(
                value: e.done,
                onChanged: (v) => model.library.setDone(e, v ?? false),
              ),
              title: e.title,
              subtitle: formatDue((e.reminder ?? e.due)!, now),
            ),
        ],
      ),
    );
  }

  static String _endOfToday(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}T23:59:59';
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) {
    final recent = model.flow.captures.take(2).toList();
    final now = model.env.now();
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader('Recent capture', onViewAll: () => model.section.value = Section.recordings),
          const SizedBox(height: 10),
          if (recent.isEmpty) const EmptyNote('No captures yet.'),
          for (final r in recent)
            _Row(
              leading: IconBadge(
                r.stage == CaptureStage.saved
                    ? Icons.check_box_outlined
                    : Icons.description_outlined,
              ),
              title: r.stage == CaptureStage.saved ? '${latestLine(r)} saved' : latestLine(r),
              subtitle: formatAgo(r.capturedAtUtc.toLocal(), now),
              onTap: () => model.section.value = Section.recordings,
            ),
        ],
      ),
    );
  }
}

class _GroupsCard extends StatelessWidget {
  const _GroupsCard({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) {
    final groups = model.settings.activeGroups.take(3).toList();
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader('Quick groups'),
          const SizedBox(height: 6),
          if (groups.isEmpty) const EmptyNote('No groups yet.'),
          for (final (i, g) in groups.indexed) ...[
            if (i > 0) const Divider(height: 1),
            InkWell(
              onTap: () => model.section.value = Section.groups,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const IconBadge(Icons.folder_open_outlined),
                    const SizedBox(width: 18),
                    Expanded(child: Text(g.name, style: Styles.body)),
                    const Icon(Icons.chevron_right, color: Palette.ink),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
