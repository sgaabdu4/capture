import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// A shortcut drawn as a key cap, e.g. "⌃⌥".
class ShortcutKeys extends StatelessWidget {
  const ShortcutKeys(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: .all(color: context.colors.outline),
      borderRadius: Radii.rounded6,
    ),
    child: Padding(
      padding: const .symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      child: Text(label, style: context.textTheme.titleMedium),
    ),
  );
}
