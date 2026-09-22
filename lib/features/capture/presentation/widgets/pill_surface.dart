import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:flutter/material.dart';

/// The charcoal capsule behind every iPhone pill, as `PillBackground` in
/// `Overlay.swift`.
class PillSurface extends StatelessWidget {
  const PillSurface({required this.padding, required this.child, super.key});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Palette.charcoal.withValues(alpha: OverlayTokens.pillOpacity),
      borderRadius: const .all(.circular(.infinity)),
      boxShadow: OverlayTokens.pillShadow,
    ),
    child: Padding(padding: padding, child: child),
  );
}
