import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/material.dart';

/// Confirms resetting Capture.
class ResetDialog extends StatelessWidget {
  const ResetDialog({required this.onCancel, required this.onReset, super.key});

  final VoidCallback onCancel;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AlertDialog(
      title: Text(l10n.resetConfirmTitle, style: textTheme.titleMedium),
      content: Text(l10n.resetConfirmBody, style: textTheme.bodyMedium),
      actions: [
        LinkButton(l10n.cancel, onPressed: onCancel),
        InkButton(
          l10n.reset,
          key: const ValueKey(AppWidgetKeys.resetConfirmButton),
          onPressed: onReset,
        ),
      ],
    );
  }
}
