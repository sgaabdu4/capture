import 'dart:async';

import 'package:capture/core/crash/crash.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

/// Recovery and pending native requests complete before the connected library sync.
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  await ref.read(nativePlatformServiceProvider).installMenu();
  await ref.read(settingsProvider.notifier).load();
  ref.read(captureFlowProvider.notifier).recoverInterrupted();
  // A "Record with Capture" that launched the app; the Mac has none.
  if (ref.read(systemDatasourceProvider).isPhone) {
    unawaited(ref.read(captureFlowProvider.notifier).takePendingRequest().catchError(Crash.error));
  }
  unawaited(ref.read(captureFlowProvider.notifier).resumeReminders());
  if (ref.read(settingsProvider).notionConnected) {
    await ref.read(libraryProvider.notifier).refresh();
  }
}
