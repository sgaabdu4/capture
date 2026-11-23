import 'package:material_ui/material_ui.dart';

/// Text input styled by the app theme; obscured fields disable suggestions and autocorrect.
class PaperField extends StatelessWidget {
  const PaperField({
    required this.controller,
    super.key,
    this.decoration,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.enabled,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    decoration: decoration,
    style: style,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    enabled: enabled,
    obscureText: obscureText,
    autocorrect: !obscureText,
    enableSuggestions: !obscureText,
    minLines: minLines,
    maxLines: maxLines,
  );
}
