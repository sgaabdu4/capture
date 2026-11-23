import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pump(WidgetTester tester, {required bool destructive}) => tester.pumpWidget(
  MaterialApp(
    theme: buildAppTheme(),
    home: Material(
      child: InkButton('Delete', destructive: destructive, onPressed: () {}),
    ),
  ),
);

Color? _fill(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton)).style?.backgroundColor?.resolve({});

void main() {
  testWidgets('a destructive button is filled with the error colour', (tester) async {
    await _pump(tester, destructive: true);

    expect(_fill(tester), Palette.error);
  });

  testWidgets('a normal button keeps the theme fill', (tester) async {
    await _pump(tester, destructive: false);

    expect(_fill(tester), isNull);
  });

  testWidgets('the label on a destructive button has 4.5 to 1 contrast', (tester) async {
    final lighter = Palette.cream.computeLuminance();
    final darker = Palette.error.computeLuminance();

    expect((lighter + 0.05) / (darker + 0.05), greaterThanOrEqualTo(4.5));
  });
}
