import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/shell/presentation/models/nav_destination.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';

/// The shell's destinations along the bottom of a narrow window, on the
/// sidebar's paper with every label shown.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.destinations,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<NavDestination> destinations;

  /// Index of the destination on screen.
  final int selected;
  final ValueChanged<NavDestination> onSelected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.paper.sidebar,
      border: Border(top: .new(color: context.paper.line)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xs),
        child: Row(
          spacing: Spacing.xxs,
          children: [
            for (final (index, destination) in destinations.indexed)
              Expanded(
                child: BottomNavItem(
                  key: ValueKey(destination.key),
                  icon: destination.icon,
                  label: destination.label,
                  selected: index == selected,
                  onTap: () => onSelected(destination),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
