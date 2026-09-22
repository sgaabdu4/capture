import 'dart:math';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/features/capture/presentation/widgets/review_card_actions.dart';
import 'package:capture/features/capture/presentation/widgets/review_row_tile.dart';
import 'package:flutter/material.dart';

/// "Ready to save?" with the proposal's rows and No / Yes, save / Edit, as
/// `ReviewCard` in `Overlay.swift`, at the phone's width. Opaque, because
/// the app's own page is behind it.
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    required this.countLine,
    required this.rows,
    required this.canApprove,
    required this.onYes,
    required this.onNo,
    required this.onEdit,
    required this.onLater,
    super.key,
    this.blockedReason,
  });

  final String countLine;
  final List<ReviewRowView> rows;
  final bool canApprove;
  final String? blockedReason;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final VoidCallback onEdit;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Palette.charcoal,
        borderRadius: OverlayTokens.cardRadius,
        border: .all(color: Palette.cardEdge),
        boxShadow: OverlayTokens.cardShadow,
      ),
      child: Padding(
        padding: OverlayTokens.cardPadding,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(l10n.editorTitle, style: OverlayTokens.cardTitle),
                      Text(l10n.reviewCardSubtitle, style: OverlayTokens.cardSubtitle),
                      if (countLine.isNotEmpty) Text(countLine, style: OverlayTokens.cardCount),
                    ],
                  ),
                ),
                IconButton(
                  key: const ValueKey(AppWidgetKeys.reviewCloseButton),
                  tooltip: l10n.reviewLater,
                  onPressed: onLater,
                  icon: const Icon(
                    Icons.close,
                    size: OverlayTokens.cardCloseIcon,
                    color: Palette.creamMuted,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const .only(top: OverlayTokens.cardGap),
              // The Mac's frame: 74 pt a row, scrolling past 300.
              child: SizedBox(
                height: min(rows.length * OverlayTokens.rowHeight, OverlayTokens.rowsMaxHeight),
                child: ListView.separated(
                  padding: .zero,
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: OverlayTokens.rowGap),
                  itemBuilder: (_, i) => ReviewRowTile(row: rows[i]),
                ),
              ),
            ),
            if (blockedReason case final String reason)
              Padding(
                padding: const .only(top: OverlayTokens.reasonGap),
                child: Text(reason, style: OverlayTokens.cardReason),
              ),
            const Divider(height: OverlayTokens.ruleSpace, thickness: 1, color: Palette.cardRule),
            ReviewCardActions(onYes: canApprove ? onYes : null, onNo: onNo, onEdit: onEdit),
          ],
        ),
      ),
    );
  }
}
