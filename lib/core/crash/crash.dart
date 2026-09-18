import 'dart:async';

import 'package:flutter/foundation.dart';

/// The app's single error boundary. Capture sends no telemetry (brief:
/// "No telemetry or logs containing audio, transcripts, tokens…"), so this
/// facade has no remote provider: uncaught errors are reported to the debug
/// console by type only — never their message, which may quote user content.
abstract final class Crash {
  static Future<void> init({required FutureOr<void> Function() appRunner}) async {
    FlutterError.onError = (details) => error(details.exception, details.stack);
    PlatformDispatcher.instance.onError = (exception, stack) {
      error(exception, stack);
      return true;
    };
    await appRunner();
  }

  static void error(Object error, StackTrace? stackTrace) {
    if (!kDebugMode) return;
    debugPrint('Uncaught ${error.runtimeType}');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
