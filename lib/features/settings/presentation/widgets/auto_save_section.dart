import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// Whether a finished recording saves to Notion without the review card.
class AutoSaveSection extends StatelessWidget {
  const AutoSaveSection({required this.on, required this.onChanged, super.key});

  final bool on;
  final ValueChanged<bool> onChanged;

  void _checked(bool? value) {
    if (value case final bool checked) onChanged(checked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Underlined(l10n.autoSaveTitle),
        MergeSemantics(
          child: Row(
            crossAxisAlignment: .start,
            spacing: Spacing.xs,
            children: [
              Checkbox(
                key: const ValueKey(AppWidgetKeys.autoSaveCheckbox),
                value: on,
                onChanged: _checked,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(!on),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(l10n.autoSaveLabel, style: textTheme.titleSmall),
                      Text(l10n.autoSaveDetail, style: textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
