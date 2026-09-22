import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/features/capture/presentation/widgets/review_card_button.dart';
import 'package:flutter/material.dart';

/// No / Yes, save / Edit along the bottom of the iPhone review card.
class ReviewCardActions extends StatelessWidget {
  const ReviewCardActions({
    required this.onYes,
    required this.onNo,
    required this.onEdit,
    super.key,
  });

  /// Null while the proposal can't be saved.
  final VoidCallback? onYes;
  final VoidCallback onNo;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: OverlayTokens.buttonGap,
      children: [
        ReviewCardButton(
          key: const ValueKey(AppWidgetKeys.reviewNoButton),
          label: l10n.reviewCardNo,
          style: OverlayTokens.button,
          width: OverlayTokens.noWidth,
          fill: Palette.charcoalButton,
          onTap: onNo,
        ),
        Expanded(
          child: ReviewCardButton(
            key: const ValueKey(AppWidgetKeys.reviewYesButton),
            label: l10n.reviewCardYes,
            style: OverlayTokens.buttonOnCream,
            fill: Palette.cream,
            onTap: onYes,
          ),
        ),
        ReviewCardButton(
          key: const ValueKey(AppWidgetKeys.reviewEditButton),
          label: l10n.edit,
          style: OverlayTokens.button,
          width: OverlayTokens.editWidth,
          onTap: onEdit,
        ),
      ],
    );
  }
}
