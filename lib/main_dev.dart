import 'package:capture/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/misc.dart';

Future<void> main() => runCaptureDev();

Future<void> runCaptureDev({List<Override> overrides = const []}) async {
  enableFlutterDriverExtension();
  await app.runCapture(overrides: overrides);
}
