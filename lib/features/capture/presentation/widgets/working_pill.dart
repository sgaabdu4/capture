import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/features/capture/presentation/widgets/pill_surface.dart';
import 'package:flutter/material.dart';

/// Spinner and what Capture is doing, as `WorkingPill` in `Overlay.swift`.
class WorkingPill extends StatelessWidget {
  const WorkingPill({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) => PillSurface(
    padding: OverlayTokens.workingPadding,
    child: Row(
      mainAxisSize: .min,
      spacing: OverlayTokens.workingGap,
      children: [
        const SizedBox.square(
          dimension: OverlayTokens.spinner,
          child: CircularProgressIndicator(
            strokeWidth: OverlayTokens.spinnerStroke,
            color: Palette.creamMuted,
          ),
        ),
        Text(status, style: OverlayTokens.status),
      ],
    ),
  );
}
