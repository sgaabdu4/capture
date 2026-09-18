import 'package:capture/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/misc.dart';

Future<void> main() => runCaptureDev();

/// E2E entrypoint: the production app with the Flutter Driver extension.
/// [overrides] are for the entrypoint test; E2E runs pass none.
Future<void> runCaptureDev({List<Override> overrides = const []}) async {
  enableFlutterDriverExtension();
  await app.runCapture(overrides: overrides);
}
