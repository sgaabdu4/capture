import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:flutter/material.dart';

/// A No / Yes, save / Edit button on the iPhone review card.
class ReviewCardButton extends StatelessWidget {
  const ReviewCardButton({
    required this.label,
    required this.style,
    required this.onTap,
    super.key,
    this.width,
    this.fill = Colors.transparent,
  });

  final String label;
  final TextStyle style;

  /// Null dims and disables the button, as on the Mac.
  final VoidCallback? onTap;
  final double? width;
  final Color fill;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: onTap == null ? OverlayTokens.disabledOpacity : 1,
    duration: .zero,
    child: TapSurface(
      color: fill,
      borderRadius: OverlayTokens.buttonRadius,
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: OverlayTokens.buttonHeight,
        child: Center(child: Text(label, style: style)),
      ),
    ),
  );
}
