import 'package:capture/core/theme/breakpoints.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/widgets/groups_card.dart';
import 'package:capture/features/capture/presentation/widgets/recent_card.dart';
import 'package:capture/features/capture/presentation/widgets/today_card.dart';
import 'package:flutter/material.dart';

/// Today, Recent capture and Quick groups side by side, or stacked when
/// narrow.
class HomeCards extends StatelessWidget {
  const HomeCards({required this.today, required this.recent, required this.groups, super.key});

  final TodayCard today;
  final RecentCard recent;
  final GroupsCard groups;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const .new(maxWidth: Sizes.cardsMaxWidth),
    child: LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < Breakpoints.stacked
          ? Column(
              crossAxisAlignment: .stretch,
              spacing: Spacing.lg,
              children: [today, recent, groups],
            )
          : Row(
              crossAxisAlignment: .start,
              spacing: Spacing.lg,
              children: [
                Expanded(child: today),
                Expanded(child: recent),
                Expanded(child: groups),
              ],
            ),
    ),
  );
}
