import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Handwritten heading with the soft pencil underline used in the mockups.
class Underlined extends StatelessWidget {
  const Underlined(this.text, {super.key, this.style});

  final String text;

  /// Defaults to the card title style.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: PencilUnderlinePainter(
      color: context.paper.pencil.withValues(alpha: Opacities.pencil),
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xxs),
      child: Text(text, style: style ?? context.textTheme.titleMedium),
    ),
  );
}

/// A slightly curved stroke along the bottom edge; thicker under large text.
class PencilUnderlinePainter extends CustomPainter {
  const PencilUnderlinePainter({required this.color});

  final Color color;

  static const _largeTextHeight = 60.0;
  static const _thickStroke = 5.0;
  static const _thinStroke = 3.0;
  static const _inset = 0.02;
  static const _lift = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height > _largeTextHeight ? _thickStroke : _thinStroke
      ..strokeCap = .round
      ..style = .stroke;
    final y = size.height - Sizes.hairline;
    final path = Path()
      ..moveTo(size.width * _inset, y)
      ..quadraticBezierTo(size.width / 2, y - _lift, size.width * (1 - _inset), y + Sizes.hairline);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PencilUnderlinePainter oldDelegate) => oldDelegate.color != color;
}
