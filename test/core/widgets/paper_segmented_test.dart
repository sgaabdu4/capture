import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/paper_segmented.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the segmented control is as tall as a tap target on a desktop', (tester) async {
    debugDefaultTargetPlatformOverride = .macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: Center(
            child: PaperSegmented<String>(
              options: const [(value: 'open', label: 'Open'), (value: 'done', label: 'Done')],
              selected: 'open',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(SegmentedButton<String>)).height,
      greaterThanOrEqualTo(Sizes.tapTarget),
    );
  });
}
