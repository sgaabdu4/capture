import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// Starts Capture over, keeping the speech model.
class ResetSection extends StatelessWidget {
  const ResetSection({required this.onReset, super.key});

  /// Null while a capture is in progress.
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Underlined(l10n.resetTitle),
        Text(l10n.resetBody, style: context.textTheme.bodyMedium),
        LineButton(
          l10n.resetButton,
          key: const ValueKey(AppWidgetKeys.resetButton),
          onPressed: onReset,
        ),
      ],
    );
  }
}
