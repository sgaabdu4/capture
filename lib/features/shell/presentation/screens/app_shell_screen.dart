import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/shell/presentation/models/nav_destination.dart';
import 'package:capture/features/shell/presentation/widgets/app_sidebar.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:capture/features/shell/presentation/widgets/nav_item.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Sidebar, settings gear and the current page.
class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({required this.location, required this.child, super.key});

  /// Path of the page on screen; selects its sidebar item.
  final String location;
  final Widget child;

  bool _at(GoRouteData route) => switch (route.location) {
    '/' => location == '/',
    final path => location == path || location.startsWith('$path/'),
  };

  List<NavDestination> _destinations(AppLocalizations l10n, {required bool withHome}) => [
    if (withHome)
      .new(
        key: AppWidgetKeys.navHome,
        icon: Icons.mic_none_outlined,
        label: l10n.appTitle,
        route: const HomeRoute(),
      ),
    .new(
      key: AppWidgetKeys.navGroups,
      icon: Icons.home_outlined,
      label: l10n.navGroups,
      route: const GroupsRoute(),
    ),
    .new(
      key: AppWidgetKeys.navRecordings,
      icon: Icons.graphic_eq,
      label: l10n.navRecordings,
      route: const RecordingsRoute(),
    ),
    .new(
      key: AppWidgetKeys.navTodo,
      icon: Icons.check_box_outlined,
      label: l10n.navTodo,
      route: const TodoRoute(),
    ),
    .new(
      key: AppWidgetKeys.navUpcoming,
      icon: Icons.calendar_today_outlined,
      label: l10n.navUpcoming,
      route: const UpcomingRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final connected = ref.watch(settingsProvider.select((s) => s.notionConnected));
    final compact = context.compact;
    final page = Stack(
      children: [
        Positioned.fill(child: child),
        PositionedDirectional(
          top: compact ? Spacing.xs : Spacing.md,
          end: compact ? Spacing.xs : Spacing.lg,
          child: IconButton(
            key: const ValueKey(AppWidgetKeys.settingsButton),
            tooltip: l10n.navSettings,
            icon: const Icon(Icons.settings_outlined, size: IconSizes.s28),
            onPressed: () => const SettingsRoute().go(context),
          ),
        ),
      ],
    );
    if (compact) {
      final destinations = _destinations(l10n, withHome: true);
      final selected = destinations.indexWhere((d) => _at(d.route));
      return Scaffold(
        body: SafeArea(child: page),
        bottomNavigationBar: BottomNavBar(
          destinations: destinations,
          selected: selected < 0 ? 0 : selected,
          onSelected: (destination) => destination.route.go(context),
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            notionConnected: connected,
            onHome: () => const HomeRoute().go(context),
            onNotion: () => const SettingsRoute().go(context),
            destinations: [
              for (final NavDestination(:key, :icon, :label, :route) in _destinations(
                l10n,
                withHome: false,
              ))
                NavItem(
                  key: ValueKey(key),
                  icon: icon,
                  label: label,
                  selected: _at(route),
                  onTap: () => route.go(context),
                ),
            ],
          ),
          VerticalDivider(width: Sizes.hairline, color: context.paper.line),
          Expanded(child: page),
        ],
      ),
    );
  }
}
