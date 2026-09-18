import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/atoms/icon_badge.dart';
import 'package:capture/features/capture/presentation/widgets/home_card.dart';
import 'package:capture/features/capture/presentation/widgets/home_card_row.dart';
import 'package:flutter/material.dart';

/// One recent capture: what happened to it and how long ago.
typedef RecentItem = ({String title, String ago, bool saved});

/// The newest captures; each row opens Recordings.
class RecentCard extends StatelessWidget {
  const RecentCard({required this.items, required this.onOpen, required this.onViewAll, super.key});

  final List<RecentItem> items;
  final VoidCallback onOpen;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HomeCard(
      title: l10n.cardRecent,
      onViewAll: onViewAll,
      children: [
        if (items.isEmpty) EmptyNote(l10n.emptyCaptures),
        for (final (:title, :ago, :saved) in items)
          HomeCardRow(
            leading: IconBadge(saved ? Icons.check_box_outlined : Icons.description_outlined),
            title: title,
            subtitle: ago,
            onTap: onOpen,
          ),
      ],
    );
  }
}
