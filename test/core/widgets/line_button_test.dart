import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pump(WidgetTester tester, {required bool destructive}) => tester.pumpWidget(
  MaterialApp(
    theme: buildAppTheme(),
    home: Material(
      child: LineButton('Reset', destructive: destructive, onPressed: () {}),
    ),
  ),
);

ButtonStyle? _style(WidgetTester tester) =>
    tester.widget<OutlinedButton>(find.byType(OutlinedButton)).style;

void main() {
  testWidgets('a destructive line button draws its label and outline in the error colour', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, destructive: true);

    expect(_style(tester)?.foregroundColor?.resolve({}), Palette.error);
    expect(_style(tester)?.side?.resolve({})?.color, Palette.error);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('a disabled destructive line button dims its label and outline together', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Material(child: LineButton('Reset', destructive: true, onPressed: null)),
      ),
    );
    final dimmed = Palette.error.withValues(alpha: Opacities.disabled);

    expect(_style(tester)?.foregroundColor?.resolve({.disabled}), dimmed);
    expect(_style(tester)?.side?.resolve({.disabled})?.color, dimmed);
    expect(_style(tester)?.side?.resolve({})?.color, Palette.error);
  });

  testWidgets('a normal line button keeps the theme colours', (tester) async {
    await _pump(tester, destructive: false);

    expect(_style(tester), isNull);
  });
}
