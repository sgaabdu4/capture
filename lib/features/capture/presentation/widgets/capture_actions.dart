import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:material_ui/material_ui.dart';

/// The one action that moves a capture on, plus delete; a spinner while the pipeline works.
class CaptureActions extends StatelessWidget {
  const CaptureActions({
    required this.stage,
    required this.busy,
    required this.idle,
    required this.onRetry,
    required this.onReview,
    required this.onRetrySave,
    required this.onReviewAgain,
    required this.onDelete,
    super.key,
  });

  final CaptureStage stage;
  final bool busy;
  final bool idle;
  final VoidCallback onRetry;
  final VoidCallback onReview;
  final VoidCallback onRetrySave;
  final VoidCallback onReviewAgain;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const SizedBox.square(
        dimension: Sizes.spinner,
        child: CircularProgressIndicator(strokeWidth: Sizes.spinnerStroke),
      );
    }
    final l10n = context.l10n;
    final primary = switch (stage) {
      .recorded || .transcribed => InkButton(l10n.retry, onPressed: idle ? onRetry : null),
      .proposed => InkButton(
        l10n.review,
        key: const ValueKey(AppWidgetKeys.captureReviewButton),
        onPressed: onReview,
      ),
      .approved => InkButton(l10n.retrySave, onPressed: idle ? onRetrySave : null),
      .dismissed => InkButton(l10n.reviewAgain, onPressed: onReviewAgain),
      .saved => null,
    };
    return Row(
      mainAxisSize: .min,
      spacing: Spacing.xs,
      children: [
        ?primary,
        if (stage != .approved)
          LinkButton(l10n.delete, flush: primary == null, onPressed: onDelete),
      ],
    );
  }
}
