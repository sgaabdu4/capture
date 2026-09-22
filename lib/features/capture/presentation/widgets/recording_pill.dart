import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/features/capture/presentation/widgets/pill_surface.dart';
import 'package:capture/features/capture/presentation/widgets/waveform.dart';
import 'package:flutter/material.dart';

/// Mic, live waveform, timer and stop, as `RecordingPill` in `Overlay.swift`.
class RecordingPill extends StatelessWidget {
  const RecordingPill({
    required this.levels,
    required this.elapsed,
    required this.onStop,
    super.key,
  });

  /// 0 to 1, newest last.
  final List<double> levels;
  final Duration elapsed;
  final VoidCallback onStop;

  static String _clock(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % Duration.secondsPerMinute).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PillSurface(
      padding: OverlayTokens.recordingPadding,
      child: Row(
        mainAxisSize: .min,
        spacing: OverlayTokens.recordingGap,
        children: [
          Container(
            width: OverlayTokens.micWell,
            height: OverlayTokens.micWell,
            decoration: const BoxDecoration(shape: .circle, color: Palette.micWell),
            child: const Icon(Icons.mic_none, size: OverlayTokens.micIcon, color: Palette.cream),
          ),
          Waveform(levels: levels),
          Text(_clock(elapsed), style: OverlayTokens.timer),
          Semantics(
            button: true,
            label: l10n.stopButton,
            child: GestureDetector(
              key: const ValueKey(AppWidgetKeys.pillStopButton),
              onTap: onStop,
              child: Container(
                width: OverlayTokens.stopButton,
                height: OverlayTokens.stopButton,
                alignment: .center,
                decoration: const BoxDecoration(shape: .circle, color: Palette.cream),
                child: Container(
                  width: OverlayTokens.stopSquare,
                  height: OverlayTokens.stopSquare,
                  decoration: const BoxDecoration(
                    color: Palette.charcoal,
                    borderRadius: OverlayTokens.stopRadius,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
