import 'package:capture/core/extensions/extensions.dart';
import 'package:material_ui/material_ui.dart';

/// Single-select dropdown field styled by the app theme.
class PaperDropdown<T extends Object> extends StatelessWidget {
  const PaperDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final T? value;
  final String hint;
  final List<({T value, String label})> items;
  final ValueChanged<T>? onChanged;

  void _handle(T? next) {
    if ((next, onChanged) case (final T picked, final ValueChanged<T> changed)) {
      changed(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return DropdownButtonFormField<T>(
      initialValue: value,
      hint: Text(hint, style: textTheme.labelMedium),
      isExpanded: true,
      style: textTheme.bodyMedium,
      items: [
        for (final (:value, :label) in items)
          DropdownMenuItem<T>(
            value: value,
            child: Text(label, overflow: .ellipsis),
          ),
      ],
      onChanged: onChanged == null ? null : _handle,
    );
  }
}
