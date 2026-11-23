import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/paper_checkbox.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<List<bool>> _pump(WidgetTester tester, {required bool flush}) async {
  final taps = <bool>[];
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      home: Material(
        child: Align(
          alignment: .topLeft,
          child: PaperCheckbox(
            value: false,
            flush: flush,
            semanticLabel: 'Saving',
            onChanged: taps.add,
          ),
        ),
      ),
    ),
  );
  return taps;
}

double _drawnLeft(WidgetTester tester) {
  final box = find.byType(Checkbox);
  return tester.getTopLeft(box).dx + (tester.getSize(box).width - Checkbox.width) / 2;
}

void main() {
  testWidgets('a flush checkbox draws at the left edge and keeps a full tap area', (tester) async {
    final taps = await _pump(tester, flush: true);

    expect(_drawnLeft(tester), 0);
    expect(tester.getSize(find.byType(PaperCheckbox)), const Size.square(Sizes.tapTarget));
    await tester.tapAt(const Offset(Sizes.tapTarget - 2, Sizes.tapTarget - 2));
    expect(taps, [true]);
  });

  testWidgets('a flush checkbox meets the tap target guideline', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, flush: true);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('a flush checkbox keeps its label and checked state for assistive tools', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, flush: true);

    expect(
      tester.getSemantics(find.byType(PaperCheckbox)),
      matchesSemantics(
        label: 'Saving',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a checkbox that is not flush keeps its centred box', (tester) async {
    await _pump(tester, flush: false);

    expect(_drawnLeft(tester), (Sizes.tapTarget - Checkbox.width) / 2);
  });
}
