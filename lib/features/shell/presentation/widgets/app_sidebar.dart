import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:capture/features/shell/presentation/widgets/notion_chip.dart';
import 'package:flutter/material.dart';

/// Wordmark, destinations, Notion state and the motto.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.destinations,
    required this.notionConnected,
    required this.onHome,
    required this.onNotion,
    super.key,
  });

  /// Tilt of the handwritten motto, in radians.
  static const _mottoTilt = -0.07;

  final List<Widget> destinations;
  final bool notionConnected;
  final VoidCallback onHome;
  final VoidCallback onNotion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: Sizes.sidebarWidth,
      color: context.paper.sidebar,
      padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.xxxl, Spacing.md, Spacing.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          TapSurface(
            onTap: onHome,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Underlined(l10n.appTitle, style: context.textTheme.headlineLarge),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Spacing.xl),
            child: Column(children: destinations),
          ),
          const Spacer(),
          NotionChip(
            key: const ValueKey(AppWidgetKeys.notionChip),
            connected: notionConnected,
            onTap: onNotion,
          ),
          Padding(
            padding: const EdgeInsets.only(left: Spacing.sm, top: Spacing.xl),
            child: Transform.rotate(
              angle: _mottoTilt,
              child: Underlined(l10n.sidebarMotto, style: context.textTheme.headlineSmall),
            ),
          ),
        ],
      ),
    );
  }
}
