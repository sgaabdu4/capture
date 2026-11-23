import 'dart:io';

import 'package:capture/app/app_startup.dart';
import 'package:capture/app/capture_app.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/shell/presentation/widgets/nav_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/app_harness.dart';
import '../helpers/sample_workspace.dart';

const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

Future<void> _open(WidgetTester tester, String key) async {
  final target = find.byKey(ValueKey(key));
  await tester.ensureVisible(target);
  await _settle(tester);
  await tester.tap(target);
  await _settle(tester);
}

Future<void> _launch(WidgetTester tester, Directory support) async {
  tester.view
    ..physicalSize = referenceWindow
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer.test(
    overrides: [
      ...appOverrides(support: support, native: stubNative()),
      appStartupProvider.overrideWith((ref) async {}),
      settingsProvider.overrideWithBuild(readySettings),
      groupsRepositoryProvider.overrideWithValue(SampleGroups()),
      libraryRepositoryProvider.overrideWithValue(SampleLibrary()),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const CaptureApp()),
  );
  await _settle(tester);
}

void main() {
  late Directory support;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    await loadAppFonts();
  });
  setUp(() => support = .systemTemp.createTempSync('capture_page_actions'));
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('Refresh shows the same icon link on Groups and To-Do', (tester) async {
    await _launch(tester, support);

    for (final nav in [AppWidgetKeys.navGroups, AppWidgetKeys.navTodo]) {
      await _open(tester, nav);
      final icon = find.descendant(
        of: find.byKey(const ValueKey(AppWidgetKeys.refreshButton)),
        matching: find.byType(Icon),
      );
      expect(tester.widget<Icon>(icon).icon, Icons.refresh, reason: nav);
    }
  });

  testWidgets('the settings gear is hidden on the Settings page and back on the others', (
    tester,
  ) async {
    await _launch(tester, support);
    const gear = ValueKey(AppWidgetKeys.settingsButton);

    expect(find.byKey(gear), findsOneWidget);
    await _open(tester, AppWidgetKeys.settingsButton);
    expect(find.byKey(gear), findsNothing);

    await _open(tester, AppWidgetKeys.navTodo);
    expect(find.byKey(gear), findsOneWidget);
  });

  testWidgets('the sidebar lists Capture as a destination that is selected on Home', (
    tester,
  ) async {
    await _launch(tester, support);
    const home = ValueKey(AppWidgetKeys.navHome);

    expect(tester.widget<NavItem>(find.byKey(home)).selected, isTrue);

    await _open(tester, AppWidgetKeys.navGroups);
    expect(tester.widget<NavItem>(find.byKey(home)).selected, isFalse);
  });
}
