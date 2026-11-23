import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
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
}
