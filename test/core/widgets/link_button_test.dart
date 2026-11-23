import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a link button on the Mac has a 44 point tap target', (tester) async {
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
    expect(size.height, greaterThanOrEqualTo(44));
    expect(size.width, greaterThanOrEqualTo(44));
  });
}
