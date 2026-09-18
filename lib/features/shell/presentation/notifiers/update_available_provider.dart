import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_available_provider.g.dart';

/// True once Sparkle reports a release newer than this build.
@Riverpod(keepAlive: true)
Stream<bool> updateAvailable(Ref ref) => ref
    .watch(nativePlatformServiceProvider)
    .events
    .where((e) => e is UpdateAvailable)
    .map((_) => true);
