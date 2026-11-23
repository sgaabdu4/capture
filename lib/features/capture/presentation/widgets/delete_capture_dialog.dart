import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Confirms deleting a capture from this Mac.
class DeleteCaptureDialog extends StatelessWidget {
  const DeleteCaptureDialog({
    required this.saved,
    required this.detail,
    required this.onCancel,
    required this.onDelete,
    super.key,
  });

  /// Whether a copy of the capture is in Notion.
  final bool saved;

  /// Names the capture, so the person knows which one goes.
  final String detail;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PaperDialog(
      title: l10n.deleteTitle,
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: Spacing.xs,
        children: [
          Text(detail, style: context.textTheme.titleSmall),
          Text(
            saved ? l10n.deleteSavedBody : l10n.deleteUnsavedBody,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        LinkButton(l10n.cancel, onPressed: onCancel),
        InkButton(
          l10n.delete,
          key: const ValueKey(AppWidgetKeys.deleteConfirmButton),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
