import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/widgets/atoms/paper_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the dropdown chevron uses a palette colour', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: PaperDropdown<String>(
            value: 'a',
            hint: 'Pick',
            items: const [(value: 'a', label: 'A')],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(IconTheme.of(tester.element(find.byType(Icon))).color, Palette.muted);
  });
}
