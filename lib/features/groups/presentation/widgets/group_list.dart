import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:flutter/material.dart';

/// [GroupCard]s for the active groups, then any archived ones under their
/// own header. Active groups offer Archive (except Unsorted); archived groups
/// offer Restore.
class GroupList extends StatelessWidget {
  const GroupList({
    required this.activeGroups,
    required this.archivedGroups,
    required this.entries,
    required this.busy,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
    super.key,
  });

  final List<Group> activeGroups;
  final List<Group> archivedGroups;

  /// Every library entry; each card lists the ones filed in its group.
  final List<LibraryEntry> entries;
  final bool busy;
  final ValueChanged<Group> onEdit;

  final ValueChanged<Group> onArchive;
  final ValueChanged<Group> onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        for (final (Group(:id, :isUnsorted, archived: isArchived) && group) in [
          ...activeGroups,
          ...archivedGroups,
        ]) ...[
          if (group == archivedGroups.firstOrNull) ...[
            const SizedBox(height: Spacing.lg),
            Text(l10n.archivedHeader, style: context.textTheme.labelMedium),
            const SizedBox(height: Spacing.xs),
          ],
          GroupCard(
            key: ValueKey(id),
            group: group,
            items: entries.filedIn(id),
            busy: busy,
            onEdit: () => onEdit(group),
            onArchive: isArchived || isUnsorted ? null : () => onArchive(group),
            onRestore: isArchived && !isUnsorted ? () => onRestore(group) : null,
          ),
        ],
      ],
    );
  }
}
