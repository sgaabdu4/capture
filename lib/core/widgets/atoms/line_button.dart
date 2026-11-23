import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:material_ui/material_ui.dart';

/// Outlined secondary button.
class LineButton extends StatelessWidget {
  const LineButton(this.label, {required this.onPressed, super.key, this.destructive = false});

  final String label;
  final VoidCallback? onPressed;

  /// Draws the label and outline in the error role, for an action that wipes data.
  final bool destructive;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: destructive
        ? OutlinedButton.styleFrom(
            foregroundColor: Palette.error,
            side: const .new(color: Palette.error, width: Sizes.outline),
          )
        : null,
    child: Text(label),
  );
}
