import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/presentation/widgets/group_menu.dart';
import 'package:capture/features/capture/presentation/widgets/kind_toggle.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:flutter/material.dart';

/// Include checkbox, title, kind and group of one proposal item.
class ProposalItemHeader extends StatelessWidget {
  const ProposalItemHeader({
    required this.item,
    required this.titleController,
    required this.groups,
    required this.editable,
    required this.onChanged,
    super.key,
  });

  final ProposalItem item;
  final TextEditingController titleController;
  final List<Group> groups;
  final bool editable;
  final ValueChanged<ProposalItem> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ProposalItem(:included, :kind, :groupId) = item;
    return Row(
      children: [
        Checkbox(
          value: included,
          onChanged: editable
              ? (value) {
                  if (value case final bool on) onChanged(item.withIncluded(value: on));
                }
              : null,
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: TextField(
            controller: titleController,
            enabled: editable,
            style: context.textTheme.titleMedium,
            decoration: .new(hintText: l10n.titleHint),
            onChanged: (value) => onChanged(item.withTitle(value)),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        KindToggle(
          kind: kind,
          onChanged: editable ? (value) => onChanged(item.withKind(value)) : null,
        ),
        const SizedBox(width: Spacing.sm),
        GroupMenu(
          groups: groups,
          value: groupId,
          onChanged: editable ? (value) => onChanged(item.withGroup(value)) : null,
        ),
      ],
    );
  }
}
