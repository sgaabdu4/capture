import 'package:capture/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(initialLocation: const HomeRoute().location, routes: $appRoutes);
  ref.onDispose(router.dispose);
  return router;
}
