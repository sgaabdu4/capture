import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:flutter/material.dart';

/// Review reasons on one proposal item.
class FlagChips extends StatelessWidget {
  const FlagChips({required this.flags, super.key});

  final Set<ReviewFlag> flags;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [for (final flag in flags) Chip(label: Text(flag.label(l10n)))],
    );
  }
}
