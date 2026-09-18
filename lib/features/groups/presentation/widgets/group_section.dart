import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:flutter/material.dart';

/// A list of [GroupCard]s. Active groups offer Archive (except Unsorted);
/// archived groups offer Restore.
class GroupSection extends StatelessWidget {
  const GroupSection({
    required this.groups,
    required this.entries,
    required this.busy,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
    super.key,
  });

  final List<Group> groups;

  /// Every library entry; each card lists the ones filed in its group.
  final List<LibraryEntry> entries;
  final bool busy;
  final ValueChanged<Group> onEdit;

  final ValueChanged<Group> onArchive;
  final ValueChanged<Group> onRestore;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    children: [
      for (final group in groups)
        GroupCard(
          key: ValueKey(group.id),
          group: group,
          items: entries.filedIn(group.id),
          busy: busy,
          onEdit: () => onEdit(group),
          onArchive: group.archived || group.isUnsorted ? null : () => onArchive(group),
          onRestore: group.archived && !group.isUnsorted ? () => onRestore(group) : null,
        ),
    ],
  );
}
