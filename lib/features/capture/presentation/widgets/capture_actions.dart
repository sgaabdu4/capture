import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:flutter/material.dart';

/// The one action that moves a capture on, plus delete; a spinner while
/// the pipeline works on it.
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
    return Row(
      mainAxisSize: .min,
      children: [
        switch (stage) {
          .recorded || .transcribed => LinkButton(l10n.retry, onPressed: idle ? onRetry : null),
          .proposed => LinkButton(l10n.review, onPressed: onReview),
          .approved => LinkButton(l10n.retrySave, onPressed: idle ? onRetrySave : null),
          .dismissed => LinkButton(l10n.reviewAgain, onPressed: onReviewAgain),
          .saved => const SizedBox.shrink(),
        },
        if (stage != .approved)
          IconButton(
            tooltip: l10n.deleteFromMac,
            icon: const Icon(Icons.delete_outline, size: IconSizes.s20),
            onPressed: onDelete,
          ),
      ],
    );
  }
}
