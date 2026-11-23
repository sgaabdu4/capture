import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/icon_action.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pump(WidgetTester tester, {required bool flush}) => tester.pumpWidget(
  MaterialApp(
    theme: buildAppTheme(),
    home: Material(
      child: Align(
        alignment: .topLeft,
        child: IconAction(Icons.close, tooltip: 'Clear', flush: flush, onPressed: () {}),
      ),
    ),
  ),
);

void main() {
  testWidgets('a flush icon draws at the left edge and keeps a full tap area', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, flush: true);

    expect(tester.getTopLeft(find.byType(Icon)).dx, 0);
    expect(tester.getSize(find.byType(IconAction)), const Size.square(Sizes.tapTarget));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('an icon that is not flush stays centred in its tap area', (tester) async {
    await _pump(tester, flush: false);

    expect(tester.getTopLeft(find.byType(Icon)).dx, greaterThan(0));
  });
}
