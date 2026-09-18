import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// First-run setup on Home until everything a capture needs is in place.
/// [steps] are the same steps Settings shows.
class SetupPanel extends StatelessWidget {
  const SetupPanel({required this.steps, super.key});

  final Widget steps;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const .new(maxWidth: Sizes.setupMaxWidth),
      child: PaperCard(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Underlined(l10n.setupTitle),
            const SizedBox(height: Spacing.xs),
            Text(l10n.setupSubtitle, style: context.textTheme.labelMedium),
            const SizedBox(height: Spacing.lg),
            steps,
          ],
        ),
      ),
    );
  }
}
