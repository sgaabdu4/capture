import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/material.dart';

/// Confirms deleting a capture from this Mac.
class DeleteCaptureDialog extends StatelessWidget {
  const DeleteCaptureDialog({
    required this.saved,
    required this.onCancel,
    required this.onDelete,
    super.key,
  });

  /// Whether a copy of the capture is in Notion.
  final bool saved;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AlertDialog(
      title: Text(l10n.deleteTitle, style: textTheme.titleMedium),
      content: Text(
        saved ? l10n.deleteSavedBody : l10n.deleteUnsavedBody,
        style: textTheme.bodyMedium,
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
