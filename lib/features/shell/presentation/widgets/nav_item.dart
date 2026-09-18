import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// One sidebar destination.
class NavItem extends StatelessWidget {
  const NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.xs),
    child: TapSurface(
      color: selected ? context.paper.selected : Colors.transparent,
      borderRadius: Radii.rounded12,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        child: Row(
          spacing: Spacing.md,
          children: [
            Icon(icon, size: IconSizes.s26, color: context.colors.onSurface),
            Text(label, style: context.textTheme.labelLarge),
          ],
        ),
      ),
    ),
  );
}
