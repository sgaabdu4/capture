import 'package:capture/app/phone_localizations.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

Future<void> _pump(WidgetTester tester, String detail, {required bool phone}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      localizationsDelegates: phone
          ? PhoneLocalizationsDelegate.delegates
          : AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Padding(
          padding: const .symmetric(horizontal: Spacing.md + Spacing.xl),
          child: StepHeader(done: true, title: 'Speech model', detail: detail),
        ),
      ),
    ),
  );
}

int _lines(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.getBoxesForSelection(.new(baseOffset: 0, extentOffset: text.length)).length;
}

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('the ready speech model line fits one line on a phone window', (tester) async {
    await _pump(tester, l10n.modelReady, phone: false);

    expect(_lines(tester, l10n.modelReady), 1);
  });

  testWidgets('the ready speech model line fits one line on an iPhone', (tester) async {
    await _pump(tester, l10n.phoneModelReady, phone: true);

    expect(_lines(tester, l10n.phoneModelReady), 1);
  });

  for (final (:name, :detail) in [
    (name: 'microphone', detail: l10n.micGranted),
    (name: 'shortcut', detail: l10n.shortcutActive),
    (name: 'Notion', detail: l10n.notionConnectedTo('Workspace')),
  ]) {
    testWidgets('the $name line fits one line on a phone window', (tester) async {
      await _pump(tester, detail, phone: false);

      expect(_lines(tester, detail), 1);
    });
  }
}
