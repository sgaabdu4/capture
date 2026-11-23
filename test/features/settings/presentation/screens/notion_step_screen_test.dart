import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/settings/presentation/screens/notion_step_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

void _noop() {}

Future<List<String>> _show(WidgetTester tester, {required bool connected}) async {
  final connects = <String>[];
  final container = ProviderContainer.test();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: NotionStepScreen(
              connected: connected,
              workspaceName: 'Workspace',
              hasToken: connected,
              connecting: false,
              error: null,
              onConnect: ({required token, required pageLink}) => connects.add('$token|$pageLink'),
              onShowGuide: _noop,
            ),
          ),
        ),
      ),
    ),
  );
  return connects;
}

InkButton _button(WidgetTester tester) =>
    tester.widget<InkButton>(find.byKey(const ValueKey(AppWidgetKeys.notionConnectButton)));

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Reconnect waits for a new token or page, like Replace', (tester) async {
    final connects = await _show(tester, connected: true);

    expect(_button(tester).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey(AppWidgetKeys.notionTokenField)), 'ntn_new');
    await tester.pump();
    expect(_button(tester).onPressed, isNotNull);

    await tester.enterText(find.byKey(const ValueKey(AppWidgetKeys.notionTokenField)), '');
    await tester.enterText(find.byKey(const ValueKey(AppWidgetKeys.notionPageField)), 'https://x');
    await tester.pump();
    expect(_button(tester).onPressed, isNotNull);
    expect(connects, isEmpty);
  });

  testWidgets('Connect stays pressable on a first connection so it can name what is missing', (
    tester,
  ) async {
    await _show(tester, connected: false);

    expect(_button(tester).onPressed, isNotNull);
  });
}
