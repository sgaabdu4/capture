import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:flutter/material.dart';

/// Live input level bars, as `Waveform` in `Overlay.swift`.
class Waveform extends StatelessWidget {
  const Waveform({required this.levels, super.key});

  /// 0 to 1, newest last.
  final List<double> levels;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: OverlayTokens.waveWidth,
    height: OverlayTokens.waveHeight,
    child: Row(
      spacing: OverlayTokens.barGap,
      children: [
        for (final level in levels)
          Container(
            width: OverlayTokens.barWidth,
            height: (level * OverlayTokens.waveHeight).clamp(
              OverlayTokens.barMin,
              OverlayTokens.waveHeight,
            ),
            decoration: BoxDecoration(
              color: level > OverlayTokens.quietLevel
                  ? Palette.cream
                  : Palette.cream.withValues(alpha: OverlayTokens.quietOpacity),
              borderRadius: OverlayTokens.barRadius,
            ),
          ),
      ],
    ),
  );
}
