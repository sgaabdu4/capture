import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/expandable_card.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:flutter/material.dart';

/// One group: name, description, saved count and an expandable list of what
/// is filed there. A null [onArchive]/[onRestore] hides that action; [busy]
/// disables every action.
class GroupCard extends StatelessWidget {
  const GroupCard({
    required this.group,
    required this.items,
    required this.busy,
    required this.onEdit,
    required this.onOpenEntry,
    super.key,
    this.onArchive,
    this.onRestore,
  });

  /// How many filed entries the expanded card lists.
  static const _maxItems = 20;

  final Group group;

  /// Library entries filed in [group].
  final List<LibraryEntry> items;
  final bool busy;
  final VoidCallback onEdit;

  /// Opens a filed note or task for editing.
  final ValueChanged<LibraryEntry> onOpenEntry;
  final VoidCallback? onArchive;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final TextTheme(:titleMedium, :labelMedium, :bodySmall, :bodyMedium) = context.textTheme;
    return ExpandableCard(
      title: Text(
        group.name.value,
        style: titleMedium?.copyWith(
          color: group.archived ? context.colors.onSurfaceVariant : context.colors.onSurface,
        ),
      ),
      subtitle: Text(group.description ?? '', style: labelMedium),
      trailing: Row(
        mainAxisSize: .min,
        spacing: Spacing.xs,
        children: [
          Text(l10n.groupSavedCount(items.length), style: bodySmall),
          IconButton(
            tooltip: l10n.edit,
            icon: const Icon(Icons.edit_outlined, size: IconSizes.s20),
            onPressed: busy ? null : onEdit,
          ),
          if (onArchive case final VoidCallback archive)
            IconButton(
              tooltip: l10n.archive,
              icon: const Icon(Icons.archive_outlined, size: IconSizes.s20),
              onPressed: busy ? null : archive,
            ),
          if (onRestore case final VoidCallback restore)
            IconButton(
              tooltip: l10n.restore,
              icon: const Icon(Icons.unarchive_outlined, size: IconSizes.s20),
              onPressed: busy ? null : restore,
            ),
        ],
      ),
      children: [
        if (items.isEmpty) EmptyNote(l10n.emptyGroupItems),
        for (final entry in items.take(_maxItems))
          ListTile(
            dense: true,
            shape: const RoundedRectangleBorder(borderRadius: Radii.rounded10),
            onTap: () => onOpenEntry(entry),
            leading: Icon(switch (entry) {
              LibraryEntry(kind: .note) => Icons.description_outlined,
              LibraryEntry(done: true) => Icons.check_box_outlined,
              LibraryEntry() => Icons.check_box_outline_blank,
            }, color: context.colors.onSurface),
            title: Text(entry.title ?? '', style: bodyMedium),
          ),
      ],
    );
  }
}
