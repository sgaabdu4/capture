import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/paper_segmented.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Rows of the picture that hold the selected segment's ink fill.
Future<int> _filledRows(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey(AppWidgetKeys.controlShot)),
  );
  final ui.Image image = await boundary.toImage();
  final ByteData? data = await image.toByteData();
  if (data == null) return 0;
  final int ink = Palette.ink.toARGB32();
  final Set<int> rows = {};
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final int offset = (y * image.width + x) * 4;
      final int pixel =
          (0xFF << 24) |
          (data.getUint8(offset) << 16) |
          (data.getUint8(offset + 1) << 8) |
          data.getUint8(offset + 2);
      if (pixel == ink) rows.add(y);
    }
  }
  return rows.length;
}

void main() {
  testWidgets('the outline of the segmented control has 3 to 1 contrast against the page', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: PaperSegmented<String>(
            options: const [(value: 'open', label: 'Open'), (value: 'done', label: 'Done')],
            selected: 'open',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    final style = Theme.of(tester.element(find.byType(SegmentedButton<String>)))
        .segmentedButtonTheme
        .style;

    final edge = style?.side?.resolve({})?.color ?? Palette.transparent;
    final ratio = (Palette.paper.computeLuminance() + 0.05) / (edge.computeLuminance() + 0.05);
    expect(ratio, greaterThanOrEqualTo(3));
  });

  testWidgets('the segmented control corners use the 12 point radius token, not a full pill', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Material(
          child: PaperSegmented<String>(
            options: const [(value: 'open', label: 'Open'), (value: 'done', label: 'Done')],
            selected: 'open',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    final style = Theme.of(tester.element(find.byType(SegmentedButton<String>)))
        .segmentedButtonTheme
        .style;

    expect(style?.shape?.resolve({}), const RoundedRectangleBorder(borderRadius: Radii.rounded12));
  });

  testWidgets('the selected segment is drawn as tall as a tap target', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: RepaintBoundary(
            key: const ValueKey(AppWidgetKeys.controlShot),
            child: ColoredBox(
              color: Palette.paper,
              child: Center(
                child: PaperSegmented<String>(
                  options: const [(value: 'open', label: 'Open'), (value: 'done', label: 'Done')],
                  selected: 'open',
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final int? rows = await tester.runAsync(() => _filledRows(tester));

    const outline = 2;
    expect(rows, isNotNull);
    expect(rows, greaterThanOrEqualTo(Sizes.tapTarget - outline));
  });
}
