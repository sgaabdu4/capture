import 'package:capture/core/theme/radii.dart';
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

  /// Inset of the header and children inside the card; the header's hover
  /// fills the card edge to edge.
  static const _headerPadding = EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.md, Spacing.sm);
  static const _bodyPadding = EdgeInsets.only(
    left: Spacing.lg,
    right: Spacing.md,
    bottom: Spacing.md,
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.sm),
    child: PaperCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: Radii.rounded18,
        child: ExpansionTile(
          tilePadding: _headerPadding,
          shape: const Border(),
          collapsedShape: const Border(),
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          expandedCrossAxisAlignment: expandedCrossAxisAlignment,
          childrenPadding: _bodyPadding.add(childrenPadding ?? EdgeInsets.zero),
          children: children,
        ),
      ),
    ),
  );
}
