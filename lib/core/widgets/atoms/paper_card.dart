import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Soft, paper-like card from the references.
class PaperCard extends StatelessWidget {
  const PaperCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(Spacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: paper.card,
        borderRadius: Radii.rounded18,
        border: .fromBorderSide(.new(color: paper.line.withValues(alpha: Opacities.cardLine))),
        boxShadow: [
          .new(
            color: paper.shadow,
            blurRadius: Sizes.shadowBlur,
            offset: const .new(0, Sizes.shadowOffset),
          ),
        ],
      ),
      child: child,
    );
  }
}
