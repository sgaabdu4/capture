import 'package:capture/app/app_model.dart';
import 'package:capture/ui/editor_page.dart';
import 'package:capture/ui/groups_page.dart';
import 'package:capture/ui/home_page.dart';
import 'package:capture/ui/recordings_page.dart';
import 'package:capture/ui/settings_page.dart';
import 'package:capture/ui/tasks_pages.dart';
import 'package:capture/ui/theme.dart';
import 'package:capture/ui/widgets.dart';
import 'package:flutter/material.dart';

class CaptureApp extends StatelessWidget {
  const CaptureApp({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Capture',
    debugShowCheckedModeBanner: false,
    theme: captureTheme(),
    home: Shell(model: model),
  );
}

class Shell extends StatelessWidget {
  const Shell({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        Sidebar(model: model),
        const VerticalDivider(width: 1, color: Palette.line),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: ValueListenableBuilder(
                  valueListenable: model.section,
                  builder: (context, section, _) => _page(section),
                ),
              ),
              Positioned(
                top: 18,
                right: 22,
                child: IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_outlined, size: 28),
                  color: Palette.ink,
                  onPressed: () => model.section.value = Section.settings,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _page(Section section) => switch (section) {
    Section.home => HomePage(model: model),
    Section.groups => GroupsPage(model: model),
    Section.recordings => RecordingsPage(model: model),
    Section.todo => TodoPage(model: model),
    Section.upcoming => UpcomingPage(model: model),
    Section.settings => SettingsPage(model: model),
    Section.editor => EditorPage(model: model),
  };
}

class Sidebar extends StatelessWidget {
  const Sidebar({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => Container(
    width: 260,
    color: Palette.sidebar,
    padding: const EdgeInsets.fromLTRB(18, 64, 18, 28),
    child: ValueListenableBuilder(
      valueListenable: model.section,
      builder: (context, section, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => model.section.value = Section.home,
                child: const Underlined('Capture', style: Styles.wordmark),
              ),
            ),
          ),
          const SizedBox(height: 40),
          for (final (s, icon, label) in _nav)
            _NavItem(
              icon: icon,
              label: label,
              selected: section == s,
              onTap: () => model.section.value = s,
            ),
          const Spacer(),
          _NotionChip(model: model),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Transform.rotate(
              angle: -0.07,
              child: const Underlined(
                'A calmer mind\ngets more done.',
                style: TextStyle(
                  fontFamily: Fonts.title,
                  fontSize: 24,
                  color: Palette.muted,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  static const _nav = [
    (Section.groups, Icons.home_outlined, 'Groups'),
    (Section.recordings, Icons.graphic_eq, 'Recordings'),
    (Section.todo, Icons.check_box_outlined, 'To-Do'),
    (Section.upcoming, Icons.calendar_today_outlined, 'Upcoming'),
  ];
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Material(
      color: selected ? Palette.selected : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 26, color: Palette.ink),
              const SizedBox(width: 20),
              Text(label, style: Styles.body.copyWith(fontSize: 20)),
            ],
          ),
        ),
      ),
    ),
  );
}

class _NotionChip extends StatelessWidget {
  const _NotionChip({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.settings,
    builder: (context, _) {
      final connected = model.settings.notionConnected;
      return Material(
        color: Palette.card,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => model.section.value = Section.settings,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Palette.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusDot(connected ? Palette.ok : Palette.warn),
                const SizedBox(width: 12),
                Text(
                  connected ? 'Notion connected' : 'Notion not connected',
                  style: Styles.label.copyWith(color: Palette.ink),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 18, color: Palette.ink),
              ],
            ),
          ),
        ),
      );
    },
  );
}
