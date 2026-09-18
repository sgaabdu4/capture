import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/shell/presentation/widgets/app_sidebar.dart';
import 'package:capture/features/shell/presentation/widgets/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sidebar, settings gear and the current page.
class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({required this.location, required this.child, super.key});

  /// Path of the page on screen; selects its sidebar item.
  final String location;
  final Widget child;

  bool _at(String path) => location == path || location.startsWith('$path/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final connected = ref.watch(settingsProvider.select((s) => s.notionConnected));
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            notionConnected: connected,
            onHome: () => const HomeRoute().go(context),
            onNotion: () => const SettingsRoute().go(context),
            destinations: [
              NavItem(
                key: const ValueKey(AppWidgetKeys.navGroups),
                icon: Icons.home_outlined,
                label: l10n.navGroups,
                selected: _at(const GroupsRoute().location),
                onTap: () => const GroupsRoute().go(context),
              ),
              NavItem(
                key: const ValueKey(AppWidgetKeys.navRecordings),
                icon: Icons.graphic_eq,
                label: l10n.navRecordings,
                selected: _at(const RecordingsRoute().location),
                onTap: () => const RecordingsRoute().go(context),
              ),
              NavItem(
                key: const ValueKey(AppWidgetKeys.navTodo),
                icon: Icons.check_box_outlined,
                label: l10n.navTodo,
                selected: _at(const TodoRoute().location),
                onTap: () => const TodoRoute().go(context),
              ),
              NavItem(
                key: const ValueKey(AppWidgetKeys.navUpcoming),
                icon: Icons.calendar_today_outlined,
                label: l10n.navUpcoming,
                selected: _at(const UpcomingRoute().location),
                onTap: () => const UpcomingRoute().go(context),
              ),
            ],
          ),
          VerticalDivider(width: Sizes.hairline, color: context.paper.line),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: child),
                PositionedDirectional(
                  top: Spacing.md,
                  end: Spacing.lg,
                  child: IconButton(
                    key: const ValueKey(AppWidgetKeys.settingsButton),
                    tooltip: l10n.navSettings,
                    icon: const Icon(Icons.settings_outlined, size: IconSizes.s28),
                    onPressed: () => const SettingsRoute().go(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
