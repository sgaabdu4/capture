import 'package:capture/core/theme/fonts.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:flutter/material.dart';

/// Measurements of the Mac's recording pill and review card
/// (`macos/Runner/Native/Overlay.swift`), for the same pieces on iPhone.
abstract final class OverlayTokens {
  // Pills.
  static const pillOpacity = 0.96;
  static const pillShadow = [
    BoxShadow(color: Palette.pillShadow, blurRadius: 10, offset: .new(0, 4)),
  ];
  static const recordingPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 9);
  static const workingPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static const reviewPillPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const recordingGap = 16.0;
  static const workingGap = 12.0;
  static const reviewPillGap = 14.0;
  static const micWell = 34.0;
  static const micIcon = 15.0;
  static const waveWidth = 118.0;
  static const waveHeight = 26.0;
  static const barWidth = 3.5;
  static const barGap = 3.0;
  static const barMin = 4.0;
  static const barRadius = BorderRadius.all(.circular(barWidth));
  static const quietLevel = 0.05;
  static const quietOpacity = 0.55;
  static const stopButton = 30.0;
  static const stopSquare = 11.0;
  static const stopRadius = BorderRadius.all(.circular(2));
  static const spinner = 16.0;
  static const spinnerStroke = 2.0;
  static const dot = 7.0;
  static const closeButton = 22.0;
  static const closeIcon = 11.0;

  // Review card.
  static const cardPadding = EdgeInsets.all(22);
  static const cardRadius = BorderRadius.all(.circular(16));
  static const cardShadow = [
    BoxShadow(color: Palette.cardShadow, blurRadius: 18, offset: .new(0, 8)),
  ];
  static const cardGap = 14.0;
  static const cardCloseIcon = 16.0;
  static const rowGap = 8.0;
  static const rowHeight = 74.0;
  static const rowsMaxHeight = 300.0;
  static const reasonGap = 10.0;
  static const ruleSpace = 28.0;
  static const rowPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  static const rowRadius = BorderRadius.all(.circular(10));
  static const rowIconGap = 18.0;
  static const rowIconWidth = 30.0;
  static const rowIcon = 24.0;
  static const buttonGap = 14.0;
  static const buttonHeight = 46.0;
  static const buttonRadius = BorderRadius.all(.circular(12));
  static const noWidth = 92.0;
  static const editWidth = 70.0;
  static const disabledOpacity = 0.45;

  // Text.
  static const timer = TextStyle(
    fontSize: 15,
    fontWeight: .w500,
    color: Palette.cream,
    fontFeatures: [.tabularFigures()],
  );
  static const status = TextStyle(fontFamily: Fonts.hand, fontSize: 17, color: Palette.cream);
  static const notSaved = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 15,
    color: Palette.creamMuted,
  );
  static const cardTitle = TextStyle(
    fontFamily: Fonts.title,
    fontSize: 34,
    fontWeight: .bold,
    color: Palette.cream,
  );
  static const cardSubtitle = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 17,
    color: Palette.creamMuted,
  );
  static const cardCount = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 14,
    color: Palette.creamMuted,
  );
  static const cardReason = TextStyle(fontFamily: Fonts.hand, fontSize: 14, color: Palette.cream);
  static const rowTitle = TextStyle(fontFamily: Fonts.hand, fontSize: 18, color: Palette.cream);
  static const rowDetail = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 15,
    color: Palette.creamMuted,
  );
  static const button = TextStyle(fontFamily: Fonts.hand, fontSize: 18, color: Palette.cream);
  static const buttonOnCream = TextStyle(fontFamily: Fonts.hand, fontSize: 18, color: Palette.ink);
}
