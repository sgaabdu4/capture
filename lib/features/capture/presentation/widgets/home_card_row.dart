import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// Leading control or badge, a title and a muted subtitle.
class HomeCardRow extends StatelessWidget {
  const HomeCardRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    super.key,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  static const _titleLines = 2;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return TapSurface(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Row(
          crossAxisAlignment: .start,
          spacing: Spacing.md,
          children: [
            leading,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: Spacing.hair,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium,
                    maxLines: _titleLines,
                    overflow: .ellipsis,
                  ),
                  Text(subtitle, style: textTheme.labelMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
