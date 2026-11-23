import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/settings/presentation/screens/typesafe_step_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Replace stays off until a new key is typed', (tester) async {
    final container = ProviderContainer.test();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildAppTheme(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TypesafeStepScreen(hasKey: true, saving: false, error: null, onSave: (_) {}),
          ),
        ),
      ),
    );
    final button = find.byKey(const ValueKey(AppWidgetKeys.typesafeSaveButton));

    expect(tester.widget<InkButton>(button).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField)), 'new-key');
    await tester.pump();

    expect(tester.widget<InkButton>(button).onPressed, isNotNull);
  });

  testWidgets('the key field and its button stay close together on a wide screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 860);
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
            body: TypesafeStepScreen(hasKey: true, saving: false, error: null, onSave: (_) {}),
          ),
        ),
      ),
    );

    final field = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField)));
    final button = tester.getTopRight(find.byKey(const ValueKey(AppWidgetKeys.typesafeSaveButton)));
    expect(button.dx - field.dx, lessThanOrEqualTo(Sizes.fieldsWidth));
  });
}
