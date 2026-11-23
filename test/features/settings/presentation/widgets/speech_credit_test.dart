import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/settings/presentation/widgets/model_step.dart';
import 'package:capture/features/settings/presentation/widgets/privacy_section.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

Widget _host(Widget child) => MaterialApp(
  theme: buildAppTheme(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('the credit is not under the Speech model heading', (tester) async {
    await tester.pumpWidget(
      _host(ModelStep(ready: true, download: null, totalBytes: 1, onDownload: () {})),
    );

    expect(find.text(l10n.modelAttribution), findsNothing);
  });

  testWidgets('Privacy opens the credit from one link and closes it again', (tester) async {
    await tester.pumpWidget(_host(const PrivacySection()));
    expect(find.text(l10n.modelAttribution), findsNothing);

    await tester.tap(find.byKey(const ValueKey(AppWidgetKeys.speechCreditButton)));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(l10n.modelAttribution), findsOneWidget);

    await tester.tap(find.text(l10n.close));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(l10n.modelAttribution), findsNothing);
  });

  testWidgets('the credit text scrolls on a short screen with large text', (tester) async {
    tester.view.physicalSize = const Size(568, 280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const .linear(2)),
          child: child ?? const SizedBox.shrink(),
        ),
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: SingleChildScrollView(child: PrivacySection())),
      ),
    );

    final link = find.byKey(const ValueKey(AppWidgetKeys.speechCreditButton));
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pump(const Duration(seconds: 1));

    final inDialog = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(Scrollable),
    );
    expect(inDialog, findsOneWidget);
    expect(
      find.descendant(of: inDialog, matching: find.text(l10n.modelAttribution)),
      findsOneWidget,
    );
    expect(find.text(l10n.close), findsOneWidget);
  });
}
