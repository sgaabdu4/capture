import 'dart:math' as math;

import 'package:capture/ui/theme.dart';
import 'package:flutter/material.dart';

/// Soft, paper-like card from the references.
class PaperCard extends StatelessWidget {
  const PaperCard({required this.child, super.key, this.padding = const EdgeInsets.all(24)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Palette.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Palette.line.withValues(alpha: 0.7)),
      boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 18, offset: Offset(0, 6))],
    ),
    child: child,
  );
}

/// Handwritten heading with the soft pencil underline used in the mockups.
class Underlined extends StatelessWidget {
  const Underlined(this.text, {super.key, this.style = Styles.cardTitle});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _UnderlinePainter(),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: style),
    ),
  );
}

class _UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.ray.withValues(alpha: 0.8)
      ..strokeWidth = size.height > 60 ? 5 : 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final y = size.height - 1;
    final path = Path()
      ..moveTo(size.width * 0.02, y)
      ..quadraticBezierTo(size.width * 0.5, y - 3, size.width * 0.98, y + 1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The large black microphone with the six pencil rays.
class MicButton extends StatelessWidget {
  const MicButton({required this.recording, required this.onPressed, super.key, this.size = 200});

  final bool recording;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: recording ? 'Stop recording' : 'Record',
    child: SizedBox(
      width: size + 150,
      height: size,
      child: CustomPaint(
        painter: _RaysPainter(radius: size / 2),
        child: Center(
          child: MouseRegion(
            cursor: onPressed == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onPressed == null ? Palette.mic.withValues(alpha: 0.45) : Palette.mic,
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 10)),
                  ],
                ),
                child: Center(
                  child: recording
                      ? Container(
                          width: size * 0.24,
                          height: size * 0.24,
                          decoration: BoxDecoration(
                            color: Palette.cream,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )
                      : Icon(Icons.mic_none_rounded, size: size * 0.42, color: Palette.cream),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _RaysPainter extends CustomPainter {
  _RaysPainter({required this.radius});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.ray
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final c = size.center(Offset.zero);
    for (final side in [-1.0, 1.0]) {
      for (final deg in [-32.0, 0.0, 32.0]) {
        final a = deg * math.pi / 180;
        final d = Offset(math.cos(a) * side, math.sin(a));
        canvas.drawLine(c + d * (radius + 26), c + d * (radius + 48), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RaysPainter old) => old.radius != radius;
}

/// Quiet text button (e.g. "View all ›").
class LinkButton extends StatelessWidget {
  const LinkButton(this.label, {required this.onPressed, super.key, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Palette.ink,
      textStyle: Styles.label,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Styles.label.copyWith(color: Palette.ink)),
        if (icon != null) ...[const SizedBox(width: 4), Icon(icon, size: 16)],
      ],
    ),
  );
}

/// Filled ink button for primary actions.
class InkButton extends StatelessWidget {
  const InkButton(this.label, {required this.onPressed, super.key, this.busy = false});
  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: Palette.ink,
      foregroundColor: Palette.cream,
      disabledBackgroundColor: Palette.ink.withValues(alpha: 0.35),
      disabledForegroundColor: Palette.cream,
      textStyle: const TextStyle(fontFamily: Fonts.hand, fontSize: 18),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: busy
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Palette.cream),
          )
        : Text(label),
  );
}

/// Outlined secondary button.
class LineButton extends StatelessWidget {
  const LineButton(this.label, {required this.onPressed, super.key});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: Palette.ink,
      side: const BorderSide(color: Palette.line, width: 1.4),
      textStyle: const TextStyle(fontFamily: Fonts.hand, fontSize: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(label),
  );
}

class StatusDot extends StatelessWidget {
  const StatusDot(this.color, {super.key});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// Circular icon badge used in list rows.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: const BoxDecoration(color: Palette.selected, shape: BoxShape.circle),
    child: Icon(icon, size: 22, color: Palette.ink),
  );
}

/// Truthful empty state.
class EmptyNote extends StatelessWidget {
  const EmptyNote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(text, style: Styles.label),
  );
}

/// Page scaffold: handwritten title, optional actions, scrollable body.
class PageFrame extends StatelessWidget {
  const PageFrame({
    required this.title,
    required this.children,
    super.key,
    this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(48, 56, 48, 48),
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Underlined(title, style: Styles.pageTitle)),
          ...actions,
        ],
      ),
      if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: Styles.label)],
      const SizedBox(height: 28),
      ...children,
    ],
  );
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
