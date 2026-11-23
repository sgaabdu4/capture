import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/widgets/atoms/paper_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<Switch> _pump(WidgetTester tester, {required bool value}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      home: Material(
        child: PaperSwitch(value: value, onChanged: (_) {}),
      ),
    ),
  );
  return tester.widget<Switch>(find.byType(Switch));
}

void main() {
  testWidgets('a switch that is off does not look like one that is on', (tester) async {
    await _pump(tester, value: false);
    final off = Theme.of(tester.element(find.byType(Switch))).switchTheme;
    const on = {WidgetState.selected};

    final (:track, :thumb) = (track: off.trackColor, thumb: off.thumbColor);
    expect(track?.resolve({}), isNot(track?.resolve(on)));
    expect(thumb?.resolve({}), isNot(thumb?.resolve(on)));
  });
}
