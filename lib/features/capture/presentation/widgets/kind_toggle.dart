import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:flutter/material.dart';

/// Note / Task switch for one proposal item; read-only when [onChanged] is null.
class KindToggle extends StatelessWidget {
  const KindToggle({required this.kind, required this.onChanged, super.key});

  final ItemKind kind;
  final ValueChanged<ItemKind>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onChanged = this.onChanged;
    return SegmentedButton<ItemKind>(
      segments: [
        for (final k in ItemKind.values) ButtonSegment(value: k, label: Text(k.label(l10n))),
      ],
      selected: {kind},
      showSelectedIcon: false,
      onSelectionChanged: switch (onChanged) {
        final ValueChanged<ItemKind> changed => (selection) {
          if (selection.firstOrNull case final ItemKind picked) changed(picked);
        },
        null => null,
      },
    );
  }
}
