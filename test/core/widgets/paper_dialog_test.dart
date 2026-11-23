import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

const _body =
    'The audio and transcript are removed from this Mac. The copy in Notion stays. They cannot come back.';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('dialog text is no wider than the dialog token', (tester) async {
    tester.view.physicalSize = const Size(1240, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Center(
          child: PaperDialog(title: 'Title', content: Text(_body)),
        ),
      ),
    );

    expect(tester.getSize(find.text(_body)).width, lessThanOrEqualTo(Sizes.dialogWidth));
  });

  test('the dialog backdrop is a palette colour', () {
    expect(buildAppTheme().dialogTheme.barrierColor, Palette.scrim);
  });
}
