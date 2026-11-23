import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/presentation/widgets/field_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

const _field = ValueKey('field');
const _action = ValueKey('action');

Future<void> _pump(WidgetTester tester, {required double scale, double width = 800}) async {
  tester.view.physicalSize = Size(width, 600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: .linear(scale)),
        child: child ?? const SizedBox.shrink(),
      ),
      home: const Scaffold(
        body: Align(
          alignment: .topLeft,
          child: FieldRow(
            field: SizedBox(key: _field, height: 48, width: double.infinity),
            action: SizedBox(key: _action, height: 48, width: 96),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('at normal text the action sits beside the field', (tester) async {
    await _pump(tester, scale: 1);
    final field = tester.getRect(find.byKey(_field));
    final action = tester.getRect(find.byKey(_action));
    expect(action.left, field.right + Spacing.sm);
    expect(action.top, field.top);
  });

  testWidgets('at large text the action drops below the field', (tester) async {
    await _pump(tester, scale: 2);
    final field = tester.getRect(find.byKey(_field));
    final action = tester.getRect(find.byKey(_action));
    expect(action.top, field.bottom + Spacing.sm);
    expect(action.left, field.left);
  });

  testWidgets('the row never grows past the field width cap', (tester) async {
    await _pump(tester, scale: 1);
    expect(tester.getSize(find.byType(FieldRow)).width, Sizes.fieldsWidth);
  });
}
