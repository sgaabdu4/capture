import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/widgets/atoms/paper_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a field label sits above the field at the smallest type token or larger', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: PaperField(controller: controller, label: 'Title'),
        ),
      ),
    );

    final label = find.text('Title');
    expect(tester.widget<Text>(label).style?.fontSize, greaterThanOrEqualTo(14));
    expect(
      tester.getBottomLeft(label).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(TextField)).dy),
    );
    expect(tester.getSemantics(find.byType(TextField)).label, contains('Title'));
    semantics.dispose();
  });

  testWidgets('a field without a decoration still draws the themed border', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(child: PaperField(controller: controller)),
      ),
    );

    expect(tester.widget<TextField>(find.byType(TextField)).decoration, isNotNull);
  });
}
