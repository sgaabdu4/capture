import 'dart:async';

import 'package:flutter/foundation.dart';

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
