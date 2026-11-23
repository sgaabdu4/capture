import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('page actions sit next to the title on a wide screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(
          body: PageFrame(title: 'To-Do', actions: [Text('Refresh')], children: []),
        ),
      ),
    );

    final gap =
        tester.getTopLeft(find.text('Refresh')).dx - tester.getTopRight(find.text('To-Do')).dx;
    expect(gap, lessThanOrEqualTo(Spacing.xl));
  });
}
