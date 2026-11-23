import 'package:material_ui/material_ui.dart';

/// Two-state checkbox styled by the app theme.
class PaperCheckbox extends StatelessWidget {
  const PaperCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  void _handle(bool? next) {
    if ((next, onChanged) case (final bool checked, final ValueChanged<bool> changed)) {
      changed(checked);
    }
  }

  @override
  Widget build(BuildContext context) => Checkbox(
    value: value,
    onChanged: onChanged == null ? null : _handle,
    semanticLabel: semanticLabel,
  );
}
