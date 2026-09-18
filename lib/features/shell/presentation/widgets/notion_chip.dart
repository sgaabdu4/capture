import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/status_dot.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// Notion connection state at the foot of the sidebar; opens Settings.
class NotionChip extends StatelessWidget {
  const NotionChip({required this.connected, required this.onTap, super.key});

  final bool connected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Radii.rounded22,
        border: .fromBorderSide(.new(color: context.paper.line)),
      ),
      child: TapSurface(
        color: context.paper.card,
        borderRadius: Radii.rounded22,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
          child: Row(
            mainAxisSize: .min,
            spacing: Spacing.xs,
            children: [
              StatusDot(connected ? context.paper.ok : context.paper.warn),
              Text(
                connected ? l10n.notionConnected : l10n.notionNotConnected,
                style: context.textTheme.labelMedium?.copyWith(color: context.colors.onSurface),
              ),
              Icon(Icons.chevron_right, size: IconSizes.s18, color: context.colors.onSurface),
            ],
          ),
        ),
      ),
    );
  }
}
