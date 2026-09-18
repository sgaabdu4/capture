import 'package:capture/core/theme/sizes.dart';
import 'package:flutter/material.dart';

/// Filled ink button for primary actions; shows a spinner while [busy].
class InkButton extends StatelessWidget {
  const InkButton(this.label, {required this.onPressed, super.key, this.busy = false});

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? SizedBox.square(
            dimension: Sizes.spinner,
            child: CircularProgressIndicator(
              strokeWidth: Sizes.spinnerStroke,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : Text(label),
  );
}
