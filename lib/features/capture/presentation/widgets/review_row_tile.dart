import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:flutter/material.dart';

/// One proposed item on the iPhone review card.
typedef ReviewRowView = ({IconData icon, String title, String detail});

/// A proposed item's icon, title and detail, as `ReviewRowView` in
/// `Overlay.swift`.
class ReviewRowTile extends StatelessWidget {
  const ReviewRowTile({required this.row, super.key});

  final ReviewRowView row;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Palette.charcoalRow,
      borderRadius: OverlayTokens.rowRadius,
    ),
    child: Padding(
      padding: OverlayTokens.rowPadding,
      child: Row(
        spacing: OverlayTokens.rowIconGap,
        children: [
          SizedBox(
            width: OverlayTokens.rowIconWidth,
            child: Icon(row.icon, size: OverlayTokens.rowIcon, color: Palette.cream),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(row.title, maxLines: 2, style: OverlayTokens.rowTitle),
                if (row.detail.isNotEmpty)
                  Text(
                    row.detail,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: OverlayTokens.rowDetail,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
