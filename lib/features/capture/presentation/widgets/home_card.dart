import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/features/capture/presentation/widgets/home_card_header.dart';
import 'package:flutter/material.dart';

/// One of the Home cards: header, then its rows or empty note.
class HomeCard extends StatelessWidget {
  const HomeCard({required this.title, required this.children, super.key, this.onViewAll});

  final String title;
  final List<Widget> children;

  /// Null hides "View all".
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) => PaperCard(
    child: Column(
      crossAxisAlignment: .start,
      spacing: Spacing.xs,
      children: [
        HomeCardHeader(title: title, onViewAll: onViewAll),
        Column(crossAxisAlignment: .start, children: children),
      ],
    ),
  );
}
