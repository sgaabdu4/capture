import 'package:capture/core/theme/sizes.dart';
import 'package:material_ui/material_ui.dart';

/// Icon button for quiet inline and toolbar actions.
class IconAction extends StatelessWidget {
  const IconAction(
    this.icon, {
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.size = IconSizes.s20,
    this.color,
    this.flush = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  /// Draws the icon at the leading edge so it lines up with the content above; the tap area stays full size.
  final bool flush;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    icon: Icon(icon, size: size, color: color),
    onPressed: onPressed,
    padding: flush ? .zero : null,
    alignment: flush ? AlignmentDirectional.centerStart : .center,
    constraints: flush ? const .tightFor(width: Sizes.tapTarget, height: Sizes.tapTarget) : null,
  );
}
