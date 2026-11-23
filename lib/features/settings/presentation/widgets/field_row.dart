import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:material_ui/material_ui.dart';

/// A field with its action: side by side on a wide window, stacked on a phone or at large text.
class FieldRow extends StatelessWidget {
  const FieldRow({required this.field, required this.action, super.key});

  static const double stackAbove = 1.3;

  final Widget field;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final stacked = context.compact || MediaQuery.textScalerOf(context).scale(1) > stackAbove;
    return ConstrainedBox(
      constraints: const .new(maxWidth: Sizes.fieldsWidth),
      child: stacked
          ? Column(crossAxisAlignment: .start, spacing: Spacing.sm, children: [field, action])
          : Row(
              spacing: Spacing.sm,
              children: [
                Expanded(child: field),
                action,
              ],
            ),
    );
  }
}
