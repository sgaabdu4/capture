import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/widgets/atoms/paper_segmented.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:material_ui/material_ui.dart';

/// Note / Task switch for one proposal item; read-only when [onChanged] is null.
class KindToggle extends StatelessWidget {
  const KindToggle({required this.kind, required this.onChanged, super.key});

  final ItemKind kind;
  final ValueChanged<ItemKind>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PaperSegmented<ItemKind>(
      options: [for (final k in ItemKind.values) (value: k, label: k.label(l10n))],
      selected: kind,
      onChanged: onChanged,
    );
  }
}
