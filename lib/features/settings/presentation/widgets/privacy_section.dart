import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// What stays on this Mac and what leaves it.
class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Underlined(l10n.privacyTitle),
        Text(l10n.privacyBody, style: context.textTheme.bodyMedium),
      ],
    );
  }
}
