import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:flutter/material.dart';

/// A list row on paper that expands to show [children]: the shared shell of
/// capture and group cards.
class ExpandableCard extends StatelessWidget {
  const ExpandableCard({
    required this.title,
    required this.trailing,
    required this.children,
    super.key,
    this.subtitle,
    this.expandedCrossAxisAlignment,
    this.childrenPadding,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget trailing;
  final List<Widget> children;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.sm),
    child: PaperCard(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.md, Spacing.md),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        shape: const Border(),
        collapsedShape: const Border(),
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        expandedCrossAxisAlignment: expandedCrossAxisAlignment,
        childrenPadding: childrenPadding,
        children: children,
      ),
    ),
  );
}
