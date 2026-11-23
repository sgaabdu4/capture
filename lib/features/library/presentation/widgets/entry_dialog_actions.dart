import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:material_ui/material_ui.dart';

/// Delete, Cancel and Save in one group from the text edge (a second press confirms Delete); null [onSave] disables Save.
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
    return SizedBox(
      width: .infinity,
      child: Wrap(
        crossAxisAlignment: .center,
        spacing: Spacing.xs,
        runSpacing: Spacing.xs,
        children: [
          if (confirmingDelete)
            InkButton(
              l10n.entryDeleteConfirm,
              key: const ValueKey(AppWidgetKeys.entryDeleteConfirmButton),
              destructive: true,
              onPressed: onDelete,
            ),
          if (!confirmingDelete)
            LinkButton(
              l10n.delete,
              key: const ValueKey(AppWidgetKeys.entryDeleteButton),
              flush: true,
              destructive: true,
              onPressed: onAskDelete,
            ),
          Row(
            mainAxisSize: .min,
            spacing: Spacing.xs,
            children: [
              LinkButton(
                l10n.cancel,
                key: const ValueKey(AppWidgetKeys.entryCancelButton),
                onPressed: onCancel,
              ),
              InkButton(
                l10n.save,
                key: const ValueKey(AppWidgetKeys.entrySaveButton),
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
