import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/material.dart';

/// Step-by-step pictures of creating the Notion connection and adding it to
/// a page. Screenshots have names and the token masked out.
class NotionGuideDialog extends StatelessWidget {
  const NotionGuideDialog({required this.onClose, super.key});

  final VoidCallback onClose;

  static String _picture(int step) => 'assets/tutorial/notion-$step.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final steps = [
      l10n.notionGuideStep1,
      l10n.notionGuideStep2,
      l10n.notionGuideStep3,
      l10n.notionGuideStep4,
      l10n.notionGuideStep5,
      l10n.notionGuideStep6,
    ];
    return AlertDialog(
      title: Text(l10n.notionGuideTitle, style: textTheme.titleMedium),
      content: SizedBox(
        width: Sizes.guideWidth,
        height: Sizes.guideHeight,
        child: ListView(
          children: [
            for (final (index, step) in steps.indexed)
              Padding(
                padding: const .only(bottom: Spacing.lg),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: Spacing.sm,
                  children: [
                    Text(l10n.numberedStep(index + 1, step), style: textTheme.bodyMedium),
                    ClipRRect(
                      borderRadius: Radii.rounded10,
                      // The step text above says what the picture shows.
                      child: Image.asset(_picture(index + 1), excludeFromSemantics: true),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [LinkButton(l10n.close, onPressed: onClose)],
    );
  }
}
