import 'package:capture/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  const StatusDot(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: Sizes.statusDot,
    height: Sizes.statusDot,
    decoration: BoxDecoration(color: color, shape: .circle),
  );
}
