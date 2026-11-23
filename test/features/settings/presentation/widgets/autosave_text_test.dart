import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/widgets/auto_save_section.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('the auto-save explanation fits one line on a phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Padding(
            padding: .symmetric(horizontal: Spacing.md + Spacing.xl),
            child: AutoSaveSection(on: false, onChanged: _ignore),
          ),
        ),
      ),
    );

    final paragraph = tester.renderObject<RenderParagraph>(find.text(l10n.autoSaveDetail));
    final lines = paragraph
        .getBoxesForSelection(.new(baseOffset: 0, extentOffset: l10n.autoSaveDetail.length))
        .length;
    expect(lines, 1);
  });
}

void _ignore(bool value) {}
