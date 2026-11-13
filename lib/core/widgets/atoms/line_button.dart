import 'package:material_ui/material_ui.dart';

/// Outlined secondary button.
class LineButton extends StatelessWidget {
  const LineButton(this.label, {required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(onPressed: onPressed, child: Text(label));
}
