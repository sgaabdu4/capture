import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Tick or empty circle, a step title and its explanation.
class StepHeader extends StatelessWidget {
  const StepHeader({required this.done, required this.title, super.key, this.detail});

  final bool done;
  final String title;
  final String? detail;

  /// Lines a step's controls up under its title.
  static const bodyInset = EdgeInsetsDirectional.only(
    start: IconSizes.s24 + Spacing.sm,
    top: Spacing.sm,
  );

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    final textTheme = context.textTheme;
    return Row(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? paper.ok : paper.faint,
          size: IconSizes.s24,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: textTheme.titleSmall),
              if (detail case final String text) Text(text, style: textTheme.labelMedium),
            ],
          ),
        ),
      ],
    );
  }
}
