import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/status_dot.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// Small print in the page's bottom corner: checks for updates, or offers the
/// download once one is found. Backed by the page colour so scrolled content
/// never shows through it.
class UpdateLink extends StatelessWidget {
  const UpdateLink({required this.updateAvailable, required this.onTap, super.key});

  final bool updateAvailable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final small = context.textTheme.bodySmall;
    return TapSurface(
      color: context.colors.surface,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: Spacing.xxs),
        child: Row(
          mainAxisSize: .min,
          spacing: Spacing.xxs,
          children: [
            if (updateAvailable) StatusDot(context.paper.ok),
            Text(
              updateAvailable ? l10n.updateDownloadNow : l10n.checkForUpdates,
              style: updateAvailable ? small?.copyWith(color: context.colors.onSurface) : small,
            ),
          ],
        ),
      ),
    );
  }
}
