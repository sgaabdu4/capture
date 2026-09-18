import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Six pencil rays, three either side of the mic circle.
class MicRaysPainter extends CustomPainter {
  const MicRaysPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  static const _stroke = 3.5;
  static const _spreadDegrees = 32.0;
  static const _innerGap = 26.0;
  static const _outerGap = 48.0;
  static const _halfTurnDegrees = 180;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _stroke
      ..strokeCap = .round;
    final c = size.center(.zero);
    for (final side in const [-1.0, 1.0]) {
      for (final deg in const [-_spreadDegrees, 0.0, _spreadDegrees]) {
        final a = deg * math.pi / _halfTurnDegrees;
        final d = Offset(math.cos(a) * side, math.sin(a));
        canvas.drawLine(c + d * (radius + _innerGap), c + d * (radius + _outerGap), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MicRaysPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.color != color;
}
