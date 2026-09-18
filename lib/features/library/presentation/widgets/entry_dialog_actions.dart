import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/material.dart';

/// Delete on the left (a second press confirms), Cancel and Save on the
/// right. A null [onSave] disables Save.
class EntryDialogActions extends StatelessWidget {
  const EntryDialogActions({
    required this.confirmingDelete,
    required this.onAskDelete,
    required this.onDelete,
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  final bool confirmingDelete;
  final VoidCallback onAskDelete;
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: Spacing.xs,
      children: [
        if (confirmingDelete)
          InkButton(
            l10n.entryDeleteConfirm,
            key: const ValueKey(AppWidgetKeys.entryDeleteConfirmButton),
            onPressed: onDelete,
          ),
        if (!confirmingDelete)
          LinkButton(
            l10n.delete,
            key: const ValueKey(AppWidgetKeys.entryDeleteButton),
            onPressed: onAskDelete,
          ),
        const Spacer(),
        LinkButton(l10n.cancel, onPressed: onCancel),
        InkButton(l10n.save, key: const ValueKey(AppWidgetKeys.entrySaveButton), onPressed: onSave),
      ],
    );
  }
}
