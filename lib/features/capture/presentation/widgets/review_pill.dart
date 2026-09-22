import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/features/capture/presentation/widgets/pill_surface.dart';
import 'package:flutter/material.dart';

/// Idle pill under the review card (the mic is off), as `ReviewPill` in
/// `Overlay.swift`; its close button leaves the capture for later.
class ReviewPill extends StatelessWidget {
  const ReviewPill({required this.onLater, super.key});

  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PillSurface(
      padding: OverlayTokens.reviewPillPadding,
      child: Row(
        mainAxisSize: .min,
        spacing: OverlayTokens.reviewPillGap,
        children: [
          Container(
            width: OverlayTokens.dot,
            height: OverlayTokens.dot,
            decoration: const BoxDecoration(shape: .circle, color: Palette.creamMuted),
          ),
          Text(l10n.reviewPillNotSaved, style: OverlayTokens.notSaved),
          Semantics(
            button: true,
            label: l10n.reviewLater,
            child: GestureDetector(
              key: const ValueKey(AppWidgetKeys.reviewLaterButton),
              onTap: onLater,
              child: Container(
                width: OverlayTokens.closeButton,
                height: OverlayTokens.closeButton,
                decoration: const BoxDecoration(shape: .circle, color: Palette.charcoalButton),
                child: const Icon(Icons.close, size: OverlayTokens.closeIcon, color: Palette.cream),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
