import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Keep names and tokens masked in the setup screenshots.
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
    return PaperDialog(
      title: l10n.notionGuideTitle,
      width: Sizes.guideWidth,
      content: SizedBox(
        width: Sizes.guideWidth,
        height: Sizes.guideHeight,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) => Padding(
            key: ValueKey(AppWidgetKeys.notionGuideStep(index + 1)),
            padding: const .only(bottom: Spacing.lg),
            child: Column(
              crossAxisAlignment: .start,
              spacing: Spacing.sm,
              children: [
                Text(l10n.numberedStep(index + 1, steps[index]), style: textTheme.bodyMedium),
                ClipRRect(
                  borderRadius: Radii.rounded10,
                  // The step text above says what the picture shows.
                  child: Image.asset(_picture(index + 1), excludeFromSemantics: true),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [LinkButton(l10n.close, onPressed: onClose)],
    );
  }
}
