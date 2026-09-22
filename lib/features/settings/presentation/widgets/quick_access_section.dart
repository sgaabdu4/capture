import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// iPhone: where "Record with Capture" lives and how to add it, using
/// Apple's own settings. Capture cannot place these itself.
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Underlined(l10n.quickAccessTitle),
        for (final (:title, :how) in [
          (title: l10n.quickAccessControlCentre, how: l10n.quickAccessControlCentreHow),
          (title: l10n.quickAccessActionButton, how: l10n.quickAccessActionButtonHow),
          (title: l10n.quickAccessHomeScreen, how: l10n.quickAccessHomeScreenHow),
        ])
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: textTheme.titleSmall),
              Text(how, style: textTheme.bodyMedium),
            ],
          ),
      ],
    );
  }
}
