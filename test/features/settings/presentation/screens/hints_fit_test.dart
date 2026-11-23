import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/settings/presentation/screens/notion_step_screen.dart';
import 'package:capture/features/settings/presentation/screens/typesafe_step_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

void _noop() {}

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('every key and link hint shows whole on a phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer.test();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildAppTheme(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TypesafeStepScreen(hasKey: true, saving: false, error: null, onSave: (_) {}),
                  NotionStepScreen(
                    connected: true,
                    workspaceName: 'Workspace',
                    hasToken: true,
                    connecting: false,
                    error: null,
                    onConnect: ({required token, required pageLink}) {},
                    onShowGuide: _noop,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    for (final hint in [
      l10n.typesafeHintReplace,
      l10n.notionTokenHintReplace,
      l10n.notionPageHintKeep,
    ]) {
      final paragraph = tester.renderObject<RenderParagraph>(find.text(hint));
      expect(paragraph.didExceedMaxLines, isFalse, reason: hint);
    }
  });
}
