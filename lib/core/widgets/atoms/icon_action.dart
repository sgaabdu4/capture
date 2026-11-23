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
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    icon: Icon(icon, size: size, color: color),
    onPressed: onPressed,
  );
}
