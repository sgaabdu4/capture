import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

/// Once per launch: menu-bar item, saved settings and hotkey, crash
/// recovery of unfinished recordings, then a library sync when connected.
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  await ref.read(nativePlatformServiceProvider).installMenu();
  await ref.read(settingsProvider.notifier).load();
  ref.read(captureFlowProvider.notifier).recoverInterrupted();
  if (ref.read(settingsProvider).notionConnected) {
    await ref.read(libraryProvider.notifier).refresh();
  }
}
