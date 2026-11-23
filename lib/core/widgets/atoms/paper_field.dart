import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:material_ui/material_ui.dart';

/// Text input styled by the app theme; obscured fields disable suggestions and autocorrect.
class PaperField extends StatelessWidget {
  const PaperField({
    required this.controller,
    super.key,
    this.label,
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

  /// Names the field in small type above it, so it never shrinks below the smallest type token.
  final String? label;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
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
    return switch (label) {
      final String text => MergeSemantics(
        child: Column(
          crossAxisAlignment: .start,
          spacing: Spacing.xxs,
          children: [
            Text(text, style: context.textTheme.bodySmall),
            field,
          ],
        ),
      ),
      null => field,
    };
  }
}
