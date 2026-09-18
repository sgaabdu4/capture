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

  /// Narrower cards put kind and group on a second line.
  static const _oneLineWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ProposalItem(:included, :kind, :groupId) = item;
    final title = Row(
      spacing: Spacing.xs,
      children: [
        Checkbox(
          value: included,
          onChanged: editable
              ? (value) {
                  if (value case final bool on) onChanged(item.withIncluded(value: on));
                }
              : null,
        ),
        Expanded(
          child: TextField(
            controller: titleController,
            enabled: editable,
            style: context.textTheme.titleMedium,
            decoration: .new(hintText: l10n.titleHint),
            onChanged: (value) => onChanged(item.withTitle(value)),
          ),
        ),
      ],
    );
    final filing = [
      KindToggle(
        kind: kind,
        onChanged: editable ? (value) => onChanged(item.withKind(value)) : null,
      ),
      GroupMenu(
        groups: groups,
        value: groupId,
        onChanged: editable ? (value) => onChanged(item.withGroup(value)) : null,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < _oneLineWidth
          ? Column(
              crossAxisAlignment: .start,
              spacing: Spacing.xs,
              children: [
                title,
                Wrap(spacing: Spacing.sm, runSpacing: Spacing.xs, children: filing),
              ],
            )
          : Row(
              spacing: Spacing.sm,
              children: [
                Expanded(child: title),
                ...filing,
              ],
            ),
    );
  }
}
