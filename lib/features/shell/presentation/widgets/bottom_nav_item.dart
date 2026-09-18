import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// One bottom-bar destination: icon over its label, highlighted like the
/// selected sidebar item.
class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
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
  Widget build(BuildContext context) {
    final ink = selected ? context.colors.onSurface : context.paper.faint;
    return Semantics(
      button: true,
      selected: selected,
      child: TapSurface(
        color: selected ? context.paper.selected : Colors.transparent,
        borderRadius: Radii.rounded12,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          child: Column(
            mainAxisSize: .min,
            spacing: Spacing.hair,
            children: [
              Icon(icon, size: IconSizes.s24, color: ink),
              FittedBox(
                fit: .scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: context.textTheme.labelMedium?.copyWith(color: ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
