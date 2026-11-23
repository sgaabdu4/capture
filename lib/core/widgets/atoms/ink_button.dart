import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:material_ui/material_ui.dart';

/// Filled ink button for primary actions; shows a spinner while [busy].
class InkButton extends StatelessWidget {
  const InkButton(
    this.label, {
    required this.onPressed,
    super.key,
    this.busy = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  /// Fills the button with the error role, so a delete confirm matches the red Delete links.
  final bool destructive;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    style: destructive
        ? FilledButton.styleFrom(
            backgroundColor: Palette.error,
            disabledBackgroundColor: Palette.error.withValues(alpha: Opacities.disabled),
          )
        : null,
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
