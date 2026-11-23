import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/fonts.dart';
import 'package:capture/features/settings/presentation/widgets/shortcut_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the shortcut keys fall back to a font that holds the modifier symbols', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Material(child: ShortcutKeys('⌃⌥')),
      ),
    );

    final style = DefaultTextStyle.of(tester.element(find.text('⌃⌥'))).style;
    final resolved = style.merge(tester.widget<Text>(find.text('⌃⌥')).style);
    expect(resolved.fontFamilyFallback, contains(Fonts.symbolFamily));
  });
}
