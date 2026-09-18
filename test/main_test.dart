import 'dart:io';

import 'package:capture/app/capture_app.dart';
import 'package:capture/main.dart' as app;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/timezone.dart' as tz;

import 'helpers/app_harness.dart';

/// Upper bound while the booted app settles.
const _settleLimit = Duration(seconds: 5);

void main() {
  late Directory support;

  setUpAll(() async {
    registerFallbackValue(Duration.zero);
    await loadAppFonts();
  });
  setUp(() => support = .systemTemp.createTempSync('capture_main_test'));
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('the entrypoint boots the app with time zones and the crash boundary', (
    tester,
  ) async {
    tester.view
      ..physicalSize = referenceWindow
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final testOnError = FlutterError.onError;

    await app.runCapture(
      overrides: appOverrides(support: support, native: stubNative()),
    );
    expect(FlutterError.onError, isNot(same(testOnError)));
    // Give test failures back to the test binding before any frame runs.
    FlutterError.onError = testOnError;
    await tester.pumpAndSettle(const .new(milliseconds: 16), .sendSemanticsUpdate, _settleLimit);

    expect(find.byType(CaptureApp), findsOneWidget);
    expect(tz.getLocation('Europe/London').name, equals('Europe/London'));
  });
}
