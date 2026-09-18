import 'package:capture/features/shell/presentation/models/nav_destination.dart';
import 'package:flutter/material.dart';

/// The shell's destinations along the bottom of a phone-sized window.
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

  void _select(int index) {
    if (destinations.elementAtOrNull(index) case final NavDestination destination) {
      onSelected(destination);
    }
  }

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selected,
    labelBehavior: .onlyShowSelected,
    onDestinationSelected: _select,
    destinations: [
      for (final NavDestination(:key, :icon, :label) in destinations)
        NavigationDestination(key: ValueKey(key), icon: Icon(icon), label: label),
    ],
  );
}
