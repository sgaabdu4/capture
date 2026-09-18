import 'package:capture/core/extensions/extensions.dart';
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

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.xxxl, Spacing.xxl, Spacing.xxl),
    children: [
      Row(
        crossAxisAlignment: .end,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Underlined(title, style: context.textTheme.displayMedium),
            ),
          ),
          ...actions,
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
}
