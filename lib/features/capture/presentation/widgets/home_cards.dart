import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/widgets/groups_card.dart';
import 'package:capture/features/capture/presentation/widgets/recent_card.dart';
import 'package:capture/features/capture/presentation/widgets/today_card.dart';
import 'package:flutter/material.dart';

/// Today, Recent capture and Quick groups side by side.
class HomeCards extends StatelessWidget {
  const HomeCards({required this.today, required this.recent, required this.groups, super.key});

  final TodayCard today;
  final RecentCard recent;
  final GroupsCard groups;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const .new(maxWidth: Sizes.cardsMaxWidth),
    child: Row(
      crossAxisAlignment: .start,
      spacing: Spacing.lg,
      children: [
        Expanded(child: today),
        Expanded(child: recent),
        Expanded(child: groups),
      ],
    ),
  );
}
