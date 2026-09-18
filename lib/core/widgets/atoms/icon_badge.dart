import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:flutter/material.dart';

/// Circular icon badge used in list rows.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: Sizes.badge,
    height: Sizes.badge,
    decoration: BoxDecoration(color: context.paper.selected, shape: .circle),
    child: Icon(icon, size: IconSizes.s22, color: context.colors.onSurface),
  );
}
