import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One place the shell navigates to.
final class NavDestination {
  const NavDestination({
    required this.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  /// Widget key of its button, the same in the sidebar and the bottom bar.
  final String key;
  final IconData icon;
  final String label;
  final GoRouteData route;
}
