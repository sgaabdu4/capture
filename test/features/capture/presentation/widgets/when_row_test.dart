import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/test_fakes.dart';

void _noop() {}

Future<void> _show(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: WhenRow(
          due: const DueDate(2026, 11, 23, hour: 20, minute: 0),
          hasReminder: false,
          today: FakeSystem.now,
          enabled: true,
          onPickDate: _noop,
          onPickTime: _noop,
          onClear: _noop,
          onReminder: (_) {},
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
    testWidgets('the icon is centred on the chips on $platform', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await _show(tester);

      final iconCentre = tester.getCenter(find.byKey(const ValueKey(AppWidgetKeys.whenIcon))).dy;
      final chipCentre = tester
          .getCenter(find.byKey(const ValueKey(AppWidgetKeys.whenDateButton)))
          .dy;

      expect(iconCentre, closeTo(chipCentre, 0.5));
    });
  }

  testWidgets('the clear button sits with the chips and the switch starts at the left edge', (
    tester,
  ) async {
    await _show(tester);

    final switchLeft = tester
        .getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.whenReminderSwitch)))
        .dx;
    final iconLeft = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.whenIcon))).dx;
    final timeRight = tester
        .getTopRight(find.byKey(const ValueKey(AppWidgetKeys.whenTimeButton)))
        .dx;
    final clearLeft = tester
        .getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.whenClearButton)))
        .dx;

    final switchWidth = tester.getSize(find.byType(Switch)).width;

    expect(switchLeft, iconLeft);
    expect(switchWidth, lessThanOrEqualTo(Sizes.switchTrack));
    expect(clearLeft - timeRight, lessThanOrEqualTo(Spacing.md));
  });
}
