import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/sample_workspace.dart';

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('the count sits beside the name and the actions sit under the description', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final group = sampleGroups.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GroupCard(
            group: group,
            items: sampleEntries.take(2).toList(),
            busy: false,
            onEdit: () {},
            onOpenEntry: (_) {},
            onArchive: () {},
          ),
        ),
      ),
    );

    final name = tester.getRect(find.text(group.name.value));
    final description = tester.getRect(find.text(group.description ?? ''));
    final count = tester.getRect(find.text(l10n.groupSavedCount(2)));
    final edit = tester.getRect(find.byTooltip(l10n.edit));
    expect(count.left, greaterThan(name.right));
    expect(count.center.dy, closeTo(name.center.dy, name.height));
    final archive = tester.getRect(find.byTooltip(l10n.archive));
    expect(description.top, greaterThanOrEqualTo(name.bottom));
    expect(edit.top, greaterThanOrEqualTo(description.bottom));
    expect(edit.left, description.left);
    expect(archive.left - edit.right, Spacing.xs);
  });

  testWidgets('HE-NO-TEXT-WALLS: a description is cut to two lines at large text', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final longDescription = List.filled(40, 'Anything about the long work week.').join(' ');
    int edits = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const .linear(2)),
          child: child ?? const SizedBox.shrink(),
        ),
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: GroupCard(
              group: sampleGroups.first.copyWith(description: longDescription),
              items: sampleEntries,
              busy: false,
              onEdit: () => edits++,
              onOpenEntry: (_) {},
              onArchive: () {},
            ),
          ),
        ),
      ),
    );

    final card = tester.getRect(find.byType(GroupCard));
    final archive = tester.getRect(find.byTooltip(l10n.archive));
    expect(archive.right, lessThanOrEqualTo(card.right));
    expect(archive.bottom, lessThan(tester.view.physicalSize.height));
    final description = tester.getRect(find.text(longDescription));
    expect(archive.top, greaterThanOrEqualTo(description.bottom));
    final shown = tester.widget<Text>(find.text(longDescription));
    expect(shown.maxLines, 2);
    expect(shown.overflow, TextOverflow.ellipsis);
    await tester.tap(find.text(longDescription));
    expect(edits, 1);
  });
}
