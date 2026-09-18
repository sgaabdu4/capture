import 'package:capture/app/capture_app.dart';
import 'package:capture/core/crash/crash.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:timezone/data/latest.dart' as tzdata;

Future<void> main() => runCapture();

/// Boots the app behind the crash boundary. [overrides] replace providers
/// for E2E and entrypoint tests; the production app passes none.
Future<void> runCapture({List<Override> overrides = const []}) async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  await Crash.init(
    appRunner: () => runApp(ProviderScope(overrides: overrides, child: const CaptureApp())),
  );
}
