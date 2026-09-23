import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/entities/group_problem.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/presentation/extensions/group_labels.dart';
import 'package:flutter/material.dart';

/// New/edit group form over a snapshot of [groups]. Emits the trimmed
/// [GroupDraft] through [onSave] only when it is valid.
class GroupDialog extends StatefulWidget {
  const GroupDialog({
    required this.groups,
    required this.onSave,
    required this.onCancel,
    super.key,
    this.editing,
  });

  /// Every group (archived included), for the duplicate-name check.
  final List<Group> groups;

  /// The group being edited, or null for a new one.
  final Group? editing;
  final ValueChanged<GroupDraft> onSave;
  final VoidCallback onCancel;

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  static const _descriptionMinLines = 3;
  static const _descriptionMaxLines = 5;
  static const _errorMaxLines = 2;

  final _name = TextEditingController();
  final _description = TextEditingController();

  /// Problems show once the user has typed or tried to save.
  bool _showProblem = false;

  GroupDraft get _draft => (name: _name.text.trim(), description: _description.text.trim());

  GroupProblem? get _problem => groupProblem(_draft, widget.groups, editingId: widget.editing?.id);

  @override
  void initState() {
    super.initState();
    if (widget.editing case Group(:final name, :final description)) {
      _name.text = name.value;
      _description.text = description ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _changed(String _) => setState(() => _showProblem = true);

  void _save() {
    if (_problem != null) {
      setState(() => _showProblem = true);
      return;
    }
    widget.onSave(_draft);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final problem = _showProblem ? _problem : null;
    return AlertDialog(
      title: Text(
        widget.editing == null ? l10n.newGroup : l10n.editGroup,
        style: context.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: Sizes.dialogWidth,
        child: Column(
          mainAxisSize: .min,
          spacing: Spacing.sm,
          children: [
            TextField(
              key: const ValueKey(AppWidgetKeys.groupNameField),
              controller: _name,
              onChanged: _changed,
              decoration: .new(labelText: l10n.groupName),
            ),
            TextField(
              key: const ValueKey(AppWidgetKeys.groupDescriptionField),
              controller: _description,
              onChanged: _changed,
              minLines: _descriptionMinLines,
              maxLines: _descriptionMaxLines,
              decoration: .new(
                labelText: l10n.groupDescription,
                errorText: problem?.label(l10n),
                errorMaxLines: _errorMaxLines,
              ),
            ),
          ],
        ),
      ),
      actions: [
        LinkButton(l10n.cancel, onPressed: widget.onCancel),
        InkButton(
          l10n.save,
          key: const ValueKey(AppWidgetKeys.groupDialogSaveButton),
          onPressed: _save,
        ),
      ],
    );
  }
}
