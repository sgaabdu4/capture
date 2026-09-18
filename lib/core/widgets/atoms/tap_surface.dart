import 'package:capture/core/theme/radii.dart';
import 'package:flutter/material.dart';

/// The one ink/tap surface for clickable rows, chips and nav items.
class TapSurface extends StatelessWidget {
  const TapSurface({
    required this.child,
    required this.onTap,
    super.key,
    this.color = Colors.transparent,
    this.borderRadius = Radii.rounded10,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: borderRadius,
    child: InkWell(borderRadius: borderRadius, onTap: onTap, child: child),
  );
}
