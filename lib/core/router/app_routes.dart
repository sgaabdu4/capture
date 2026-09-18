import 'package:capture/app/capture_bootstrap.dart';
import 'package:capture/features/capture/presentation/screens/editor_screen.dart';
import 'package:capture/features/capture/presentation/screens/home_screen.dart';
import 'package:capture/features/capture/presentation/screens/recordings_screen.dart';
import 'package:capture/features/groups/presentation/screens/groups_screen.dart';
import 'package:capture/features/library/presentation/screens/todo_screen.dart';
import 'package:capture/features/library/presentation/screens/upcoming_screen.dart';
import 'package:capture/features/settings/presentation/screens/settings_screen.dart';
import 'package:capture/features/shell/presentation/screens/app_shell_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

@TypedShellRoute<AppShellRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(path: '/'),
    TypedGoRoute<GroupsRoute>(path: '/groups'),
    TypedGoRoute<RecordingsRoute>(
      path: '/recordings',
      routes: [TypedGoRoute<EditorRoute>(path: ':id')],
    ),
    TypedGoRoute<TodoRoute>(path: '/todo'),
    TypedGoRoute<UpcomingRoute>(path: '/upcoming'),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) => CaptureBootstrap(
    child: AppShellScreen(location: state.uri.path, child: navigator),
  );
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class GroupsRoute extends GoRouteData with $GroupsRoute {
  const GroupsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const GroupsScreen();
}

class RecordingsRoute extends GoRouteData with $RecordingsRoute {
  const RecordingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const RecordingsScreen();
}

/// The proposal editor for one capture.
class EditorRoute extends GoRouteData with $EditorRoute {
  const EditorRoute({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) => EditorScreen(captureId: id);
}

class TodoRoute extends GoRouteData with $TodoRoute {
  const TodoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TodoScreen();
}

class UpcomingRoute extends GoRouteData with $UpcomingRoute {
  const UpcomingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const UpcomingScreen();
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsScreen();
}
