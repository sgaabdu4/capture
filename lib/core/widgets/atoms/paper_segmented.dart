import 'package:material_ui/material_ui.dart';

/// Single-choice segmented control styled by the app theme.
class PaperSegmented<T extends Object> extends StatelessWidget {
  const PaperSegmented({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<({T value, String label})> options;
  final T selected;
  final ValueChanged<T>? onChanged;

  void _handle(Set<T> selection) {
    if ((selection.firstOrNull, onChanged) case (final T picked, final ValueChanged<T> changed)) {
      changed(picked);
    }
  }

  @override
  Widget build(BuildContext context) => SegmentedButton<T>(
    segments: [
      for (final (:value, :label) in options) ButtonSegment(value: value, label: Text(label)),
    ],
    selected: {selected},
    showSelectedIcon: false,
    onSelectionChanged: onChanged == null ? null : _handle,
  );
}
