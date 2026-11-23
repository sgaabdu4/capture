import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Color? _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style?.color;

void main() {
  testWidgets('a link button on the Mac has a 48 point tap target', (tester) async {
    debugDefaultTargetPlatformOverride = .macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: Center(child: LinkButton('Refresh', onPressed: () {})),
        ),
      ),
    );

    final size = tester.getSize(find.byType(TextButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  });

  testWidgets('a destructive link button names its danger with the error colour', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: Column(
            children: [
              LinkButton('Cancel', onPressed: () {}),
              LinkButton('Delete', destructive: true, onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(_labelColor(tester, 'Delete'), Palette.error);
    expect(_labelColor(tester, 'Cancel'), isNot(Palette.error));
  });

  testWidgets('a flush link button starts its text at the left edge of its slot', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: Align(
            alignment: .topLeft,
            child: LinkButton('Show me how', flush: true, onPressed: () {}),
          ),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.text('Show me how')).dx,
      tester.getTopLeft(find.byType(TextButton)).dx,
    );
  });
}
