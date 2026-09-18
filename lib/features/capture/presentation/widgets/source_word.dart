import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// One spoken word; tappable when [onTap] is set.
class SourceWord extends StatelessWidget {
  const SourceWord({required this.text, required this.onTap, super.key});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final word = Padding(
      padding: const EdgeInsets.only(right: Spacing.xxs),
      child: Text(text, style: context.textTheme.labelMedium?.copyWith(fontStyle: .italic)),
    );
    return switch (onTap) {
      final VoidCallback tap => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: tap, child: word),
      ),
      null => word,
    };
  }
}
