// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$appShellRoute];

RouteBase get $appShellRoute => ShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(path: '/', hasOverriddenOnExit: false, factory: $HomeRoute._fromState),
    GoRouteData.$route(
      path: '/groups',
      hasOverriddenOnExit: false,
      factory: $GroupsRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/recordings',
      hasOverriddenOnExit: false,
      factory: $RecordingsRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: ':recordId',
          hasOverriddenOnExit: false,
          factory: $EditorRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(path: '/todo', hasOverriddenOnExit: false, factory: $TodoRoute._fromState),
    GoRouteData.$route(
      path: '/upcoming',
      hasOverriddenOnExit: false,
      factory: $UpcomingRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/settings',
      hasOverriddenOnExit: false,
      factory: $SettingsRoute._fromState,
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupsRoute on GoRouteData {
  static GroupsRoute _fromState(GoRouterState state) => const GroupsRoute();

  @override
  String get location => GoRouteData.$location('/groups');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RecordingsRoute on GoRouteData {
  static RecordingsRoute _fromState(GoRouterState state) => const RecordingsRoute();

  @override
  String get location => GoRouteData.$location('/recordings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EditorRoute on GoRouteData {
  static EditorRoute _fromState(GoRouterState state) =>
      EditorRoute(recordId: state.pathParameters['recordId']!);

  EditorRoute get _self => this as EditorRoute;

  @override
  String get location =>
      GoRouteData.$location('/recordings/${Uri.encodeComponent(_self.recordId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TodoRoute on GoRouteData {
  static TodoRoute _fromState(GoRouterState state) => const TodoRoute();

  @override
  String get location => GoRouteData.$location('/todo');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UpcomingRoute on GoRouteData {
  static UpcomingRoute _fromState(GoRouterState state) => const UpcomingRoute();

  @override
  String get location => GoRouteData.$location('/upcoming');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
