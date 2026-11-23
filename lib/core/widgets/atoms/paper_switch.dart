import 'package:material_ui/material_ui.dart';

/// Toggle switch styled by the app theme.
class PaperSwitch extends StatelessWidget {
  const PaperSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.padding,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final control = Switch(value: value, onChanged: onChanged, padding: padding);
    return switch (semanticLabel) {
      final String label => Semantics(label: label, child: control),
      null => control,
    };
  }
}
