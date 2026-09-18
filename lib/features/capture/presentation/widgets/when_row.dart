import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:flutter/material.dart';

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
    return Row(
      spacing: Spacing.xs,
      children: [
        const Icon(Icons.calendar_today_outlined, size: IconSizes.s20),
        LineButton(switch (due) {
          final DueDate d => d.dateOnly.label(l10n, today),
          null => l10n.addDate,
        }, onPressed: enabled ? onPickDate : null),
        if (due case final DueDate d) ...[
          LineButton(switch (d.timeLabel(l10n)) {
            final String time => time,
            null => l10n.addTime,
          }, onPressed: enabled ? onPickTime : null),
          Switch(
            padding: const EdgeInsetsDirectional.only(start: Spacing.sm, end: Spacing.xxs),
            value: hasReminder,
            onChanged: enabled && d.hasTime ? onReminder : null,
          ),
          Text(
            d.hasTime ? l10n.remindMe : l10n.addTimeForReminder,
            style: context.textTheme.labelMedium,
          ),
          const Spacer(),
          if (enabled)
            IconButton(
              tooltip: l10n.removeDate,
              icon: const Icon(Icons.close, size: IconSizes.s18),
              onPressed: onClear,
            ),
        ],
      ],
    );
  }
}
