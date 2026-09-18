import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:flutter/material.dart';

/// One saved entry: a checkbox for a task or a page icon for a note, the
/// title and an optional when/group [detail] line. Tapping opens it.
class EntryRow extends StatelessWidget {
  const EntryRow({
    required this.entry,
    required this.onChanged,
    required this.onOpen,
    super.key,
    this.detail,
  });

  final LibraryEntry entry;
  final String? detail;

  /// The new done value.
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;

  void _toggled(bool? value) {
    if (value case final bool done) onChanged(done);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.xs),
    child: PaperCard(
      padding: EdgeInsets.zero,
      child: TapSurface(
        borderRadius: Radii.rounded18,
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
          child: Row(
            spacing: Spacing.sm,
            children: [
              switch (entry.kind) {
                .task => Checkbox(value: entry.done, onChanged: _toggled),
                .note => const Padding(
                  padding: EdgeInsets.all(Spacing.sm),
                  child: Icon(Icons.description_outlined),
                ),
              },
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
      ),
    ),
  );
}
