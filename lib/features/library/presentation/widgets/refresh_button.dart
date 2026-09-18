import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/material.dart';

/// "Refresh ↻" link for the library pages; null [onPressed] disables it.
class RefreshButton extends StatelessWidget {
  const RefreshButton({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LinkButton(
      l10n.refresh,
      key: const ValueKey(AppWidgetKeys.refreshButton),
      icon: Icons.refresh,
      onPressed: onPressed,
    );
  }
}
