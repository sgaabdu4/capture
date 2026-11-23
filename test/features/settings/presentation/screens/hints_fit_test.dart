import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/screens/notion_step_screen.dart';
import 'package:capture/features/settings/presentation/screens/typesafe_step_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

void _noop() {}

/// The hints that end in an ellipsis on a phone [width] points wide at [scale] times text.
Future<List<String>> _clippedHints(
  WidgetTester tester, {
  required double width,
  required double scale,
}) async {
  final l10n = lookupAppLocalizations(const Locale('en'));
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer.test();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: .linear(scale)),
          child: child ?? const SizedBox.shrink(),
        ),
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const .symmetric(horizontal: Spacing.md + Spacing.xl),
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

  return [
    for (final hint in [
      l10n.typesafeHintReplace,
      l10n.notionTokenHintReplace,
      l10n.notionPageHintKeep,
    ])
      if (tester.renderObject<RenderParagraph>(find.text(hint)).didExceedMaxLines) hint,
  ];
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('every key and link hint shows whole on a phone', (tester) async {
    expect(await _clippedHints(tester, width: 375, scale: 1), isEmpty);
  });

  testWidgets('every key and link hint shows whole on a phone at 1.5 times text', (tester) async {
    expect(await _clippedHints(tester, width: 375, scale: 1.5), isEmpty);
  });

  testWidgets('every key and link hint shows whole on a phone at 2 times text', (tester) async {
    expect(await _clippedHints(tester, width: 375, scale: 2), isEmpty);
  });

  testWidgets('every key and link hint shows whole on the narrowest phone at 1.24 times text', (
    tester,
  ) async {
    expect(await _clippedHints(tester, width: 320, scale: 1.24), isEmpty);
  });
}
