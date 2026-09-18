import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/breakpoints.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

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

  static const _wide = EdgeInsets.fromLTRB(Spacing.xxl, Spacing.xxxl, Spacing.xxl, Spacing.xxl);
  static const _compact = EdgeInsets.fromLTRB(Spacing.md, Spacing.xxxl, Spacing.md, Spacing.lg);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final base = context.compact ? _compact : _wide;
      final spare = (constraints.maxWidth - base.horizontal - Breakpoints.content) / 2;
      return ListView(
        padding: base.add(.symmetric(horizontal: spare > 0 ? spare : 0)),
        children: [
          Wrap(
            alignment: .spaceBetween,
            crossAxisAlignment: .end,
            spacing: Spacing.md,
            runSpacing: Spacing.sm,
            children: [
              Underlined(title, style: context.textTheme.displayMedium),
              Row(mainAxisSize: .min, children: actions),
            ],
          ),
          if (subtitle case final String s) ...[
            const SizedBox(height: Spacing.xs),
            Text(s, style: context.textTheme.labelMedium),
          ],
          const SizedBox(height: Spacing.lg),
          ...children,
        ],
      );
    },
  );
}
