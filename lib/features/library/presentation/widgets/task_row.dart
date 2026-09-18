import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:flutter/material.dart';

/// One open task: checkbox, title and an optional when/group [detail] line.
class TaskRow extends StatelessWidget {
  const TaskRow({required this.entry, required this.onChanged, super.key, this.detail});

  final LibraryEntry entry;
  final String? detail;

  /// The new done value.
  final ValueChanged<bool> onChanged;

  void _toggled(bool? value) {
    if (value case final bool done) onChanged(done);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.xs),
    child: PaperCard(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
      child: Row(
        spacing: Spacing.sm,
        children: [
          Checkbox(value: entry.done, onChanged: _toggled),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(entry.title, style: context.textTheme.bodyMedium),
                if (detail case final String d) Text(d, style: context.textTheme.labelMedium),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
