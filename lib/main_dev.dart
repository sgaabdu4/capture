import 'package:capture/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

/// E2E entrypoint: the production app with the Flutter Driver extension.
Future<void> main() async {
  enableFlutterDriverExtension();
  await app.runCapture();
}
