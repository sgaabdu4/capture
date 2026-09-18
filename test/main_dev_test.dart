import 'dart:io';

import 'package:capture/main_dev.dart' as dev;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart';

void main() {
  // A plain test, so the entrypoint installs its own binding.
  test('the E2E entrypoint boots the app on the Flutter Driver binding', () async {
    final support = Directory.systemTemp.createTempSync('capture_main_dev_test');
    addTearDown(() => support.deleteSync(recursive: true));

    await dev.runCaptureDev(
      overrides: appOverrides(support: support, native: stubNative()),
    );

    expect(WidgetsBinding.instance, isNot(isA<WidgetsFlutterBinding>()));
  });
}
