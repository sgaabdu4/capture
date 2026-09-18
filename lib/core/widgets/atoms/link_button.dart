import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Quiet text button (e.g. "View all ›").
class LinkButton extends StatelessWidget {
  const LinkButton(this.label, {required this.onPressed, super.key, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Row(
      mainAxisSize: .min,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(color: context.colors.onSurface),
        ),
        if (icon case final IconData i) ...[
          const SizedBox(width: Spacing.xxs),
          Icon(i, size: IconSizes.s16),
        ],
      ],
    ),
  );
}
