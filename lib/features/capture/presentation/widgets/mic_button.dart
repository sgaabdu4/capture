import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/capture_colors.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/features/capture/presentation/widgets/mic_rays_painter.dart';
import 'package:flutter/material.dart';

/// The large black microphone with the six pencil rays.
class MicButton extends StatelessWidget {
  const MicButton({
    required this.recording,
    required this.onPressed,
    super.key,
    this.size = Sizes.micDiameter,
  });

  final bool recording;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final double size;

  static const _stopFraction = 0.24;
  static const _iconFraction = 0.42;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final CaptureColors(:pencil, :mic, :micShadow) = context.paper;
    final cream = context.colors.onPrimary;
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      label: recording ? l10n.stopButton : l10n.recordButton,
      child: SizedBox(
        width: size + Sizes.micRaysExtent,
        height: size,
        child: CustomPaint(
          painter: MicRaysPainter(radius: size / 2, color: pencil),
          child: Center(
            child: MouseRegion(
              cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
              child: GestureDetector(
                key: const ValueKey(AppWidgetKeys.recordButton),
                onTap: onPressed,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: enabled ? mic : mic.withValues(alpha: Opacities.micDisabled),
                    boxShadow: [
                      .new(
                        color: micShadow,
                        blurRadius: Sizes.micShadowBlur,
                        offset: const .new(0, Sizes.micShadowOffset),
                      ),
                    ],
                  ),
                  child: Center(
                    child: recording
                        ? Container(
                            width: size * _stopFraction,
                            height: size * _stopFraction,
                            decoration: BoxDecoration(color: cream, borderRadius: Radii.rounded6),
                          )
                        : Icon(Icons.mic_none_rounded, size: size * _iconFraction, color: cream),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
