import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/status_dot.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// Small print in the page's bottom corner offering a newer release. Backed by
/// the page colour so scrolled content never shows through it.
class UpdateLink extends StatelessWidget {
  const UpdateLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TapSurface(
      color: context.colors.surface,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: Spacing.xxs),
        child: Row(
          mainAxisSize: .min,
          spacing: Spacing.xxs,
          children: [
            StatusDot(context.paper.ok),
            Text(
              l10n.updateDownloadNow,
              style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
