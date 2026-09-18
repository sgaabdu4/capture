import 'dart:io';

import 'package:capture/app/capture_app.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_harness.dart';

final _l10n = lookupAppLocalizations(const .new('en'));

/// Frame step and upper bound while waiting for the UI to settle.
const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

/// Launches the real app on the fakes in [appOverrides].
Future<void> _launch(
  WidgetTester tester, {
  required Directory support,
  required INativePlatformService native,
}) async {
  tester.view
    ..physicalSize = referenceWindow
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer.test(
    overrides: appOverrides(support: support, native: native),
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const CaptureApp()),
  );
  await _settle(tester);
}

Future<void> _open(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await _settle(tester);
}

void main() {
  late Directory support;
  late INativePlatformService native;

  setUpAll(() async {
    registerFallbackValue(Duration.zero);
    await loadAppFonts();
  });
  setUp(() {
    support = .systemTemp.createTempSync('capture_app_test');
    native = stubNative();
  });
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('first launch shows the setup steps and does not record', (tester) async {
    await _launch(tester, support: support, native: native);

    expect(find.text(_l10n.setupTitle), findsOneWidget);
    await _open(tester, AppWidgetKeys.recordButton);
    verifyNever(() => native.startRecording(any(), limit: any(named: 'limit')));
    verify(native.installMenu).called(1);
  });

  testWidgets('each page shows its truthful empty state', (tester) async {
    await _launch(tester, support: support, native: native);

    await _open(tester, AppWidgetKeys.navGroups);
    expect(find.text(_l10n.groupsNeedNotion), findsOneWidget);
    await _open(tester, AppWidgetKeys.navRecordings);
    expect(find.text(_l10n.emptyCaptures), findsOneWidget);
    await _open(tester, AppWidgetKeys.navTodo);
    expect(find.text(_l10n.emptyOpenTasks), findsOneWidget);
    await _open(tester, AppWidgetKeys.navUpcoming);
    expect(find.text(_l10n.emptyUpcoming), findsOneWidget);
    await _open(tester, AppWidgetKeys.settingsButton);
    expect(find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField)), findsOneWidget);
  });
}
