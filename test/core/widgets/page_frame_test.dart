import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
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

  testWidgets('every page subtitle takes one line on a phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final l10n = lookupAppLocalizations(const Locale('en'));
    for (final subtitle in [
      l10n.groupsSubtitle,
      l10n.syncRefreshing,
      l10n.syncedAgo('5 minutes ago'),
      l10n.entryBodyLoading,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(
            body: PageFrame(title: 'Groups', subtitle: subtitle, children: const []),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(find.text(subtitle));
      final lines = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: 0, extentOffset: subtitle.length),
      );
      expect(lines, hasLength(1), reason: subtitle);
    }
  });
}
