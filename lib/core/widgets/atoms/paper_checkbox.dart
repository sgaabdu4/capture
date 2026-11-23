import 'package:capture/core/theme/sizes.dart';
import 'package:material_ui/material_ui.dart';

/// Two-state checkbox styled by the app theme.
class PaperCheckbox extends StatelessWidget {
  const PaperCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticLabel,
    this.flush = false,
  });

  /// Room between the edge of the shrink-wrapped checkbox and the drawn box.
  static const double _boxInset = (kMinInteractiveDimension - 8 - Checkbox.width) / 2;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  /// Draws the box at the leading edge so it lines up with the content above; the tap area stays full size.
  final bool flush;

  void _handle(bool? next) {
    if ((next, onChanged) case (final bool checked, final ValueChanged<bool> changed)) {
      changed(checked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Checkbox(
      value: value,
      onChanged: onChanged == null ? null : _handle,
      semanticLabel: flush ? null : semanticLabel,
      materialTapTargetSize: flush ? .shrinkWrap : null,
      visualDensity: flush ? .standard : null,
    );
    if (!flush) return box;
    return Semantics(
      container: true,
      checked: value,
      label: semanticLabel,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => _handle(!value),
      child: GestureDetector(
        behavior: .opaque,
        onTap: onChanged == null ? null : () => _handle(!value),
        child: SizedBox.square(
          dimension: Sizes.tapTarget,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: ExcludeSemantics(
              child: Transform.translate(offset: const .new(-_boxInset, 0), child: box),
            ),
          ),
        ),
      ),
    );
  }
}
