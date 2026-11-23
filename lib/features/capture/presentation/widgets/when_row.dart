import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/icon_action.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/core/widgets/atoms/paper_switch.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:material_ui/material_ui.dart';

/// Date, time and reminder of one task.
class WhenRow extends StatelessWidget {
  const WhenRow({
    required this.due,
    required this.hasReminder,
    required this.today,
    required this.enabled,
    required this.onPickDate,
    required this.onPickTime,
    required this.onClear,
    required this.onReminder,
    super.key,
  });

  /// The due date, or the reminder when there is no due date.
  final DueDate? due;
  final bool hasReminder;

  /// Wall-clock now in the capture's time zone.
  final DateTime today;
  final bool enabled;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onClear;
  final ValueChanged<bool> onReminder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reminderLabel = (due?.hasTime ?? false) ? l10n.remindMe : l10n.addTimeForReminder;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.xs,
      children: [
        Row(
          crossAxisAlignment: .start,
          spacing: Spacing.xs,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: Spacing.xs),
              child: Icon(
                Icons.calendar_today_outlined,
                key: ValueKey(AppWidgetKeys.whenIcon),
                size: IconSizes.s20,
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                crossAxisAlignment: .center,
                children: [
                  LineButton(
                    switch (due) {
                      final DueDate d => d.dateOnly.label(l10n, today),
                      null => l10n.addDate,
                    },
                    key: const ValueKey(AppWidgetKeys.whenDateButton),
                    onPressed: enabled ? onPickDate : null,
                  ),
                  if (due case final DueDate d)
                    LineButton(
                      switch (d.timeLabel(l10n)) {
                        final String time => time,
                        null => l10n.addTime,
                      },
                      key: const ValueKey(AppWidgetKeys.whenTimeButton),
                      onPressed: enabled ? onPickTime : null,
                    ),
                  if (due != null && enabled)
                    IconAction(
                      Icons.close,
                      key: const ValueKey(AppWidgetKeys.whenClearButton),
                      tooltip: l10n.removeDate,
                      size: IconSizes.s18,
                      onPressed: onClear,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (due case final DueDate d)
          Row(
            mainAxisSize: .min,
            spacing: Spacing.xs,
            children: [
              PaperSwitch(
                key: const ValueKey(AppWidgetKeys.whenReminderSwitch),
                padding: .zero,
                semanticLabel: reminderLabel,
                value: hasReminder,
                onChanged: enabled && d.hasTime ? onReminder : null,
              ),
              Flexible(
                child: ExcludeSemantics(
                  child: Text(reminderLabel, style: context.textTheme.labelMedium),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
