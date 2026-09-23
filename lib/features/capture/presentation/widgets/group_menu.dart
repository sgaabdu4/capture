import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:flutter/material.dart';

/// Picks the group of one proposal item; read-only when [onChanged] is null.
class GroupMenu extends StatelessWidget {
  const GroupMenu({required this.groups, required this.value, required this.onChanged, super.key});

  final List<Group> groups;

  /// Selected group id; null while the user must choose.
  final NotionId? value;
  final ValueChanged<NotionId>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final onChanged = this.onChanged;
    return SizedBox(
      width: Sizes.groupMenuWidth,
      child: DropdownButtonFormField<NotionId>(
        initialValue: groups.any((g) => g.id == value) ? value : null,
        hint: Text(l10n.groupHint, style: textTheme.labelMedium),
        isExpanded: true,
        style: textTheme.bodyMedium,
        items: [
          for (final Group(:id, :name) in groups)
            DropdownMenuItem(
              value: id,
              child: Text(name.value, overflow: .ellipsis),
            ),
        ],
        onChanged: switch (onChanged) {
          final ValueChanged<NotionId> changed => (id) {
            if (id case final NotionId picked) changed(picked);
          },
          null => null,
        },
      ),
    );
  }
}
