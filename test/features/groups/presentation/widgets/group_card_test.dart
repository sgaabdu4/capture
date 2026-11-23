import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/sample_workspace.dart';

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('the count and actions sit under the description at its left edge', (tester) async {
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

    final description = tester.getRect(find.text(group.description ?? ''));
    final count = tester.getRect(find.text(l10n.groupSavedCount(2)));
    final edit = tester.getRect(find.byTooltip(l10n.edit));
    expect(count.left, description.left);
    expect(count.top, greaterThanOrEqualTo(description.bottom));
    expect(edit.left - count.right, lessThan(description.width));
    expect(edit.right, lessThan(description.left + 400));
  });

  testWidgets('large text keeps every action on the card and a long description to three lines', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final longDescription = List.filled(40, 'Anything about the long work week.').join(' ');
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
          body: GroupCard(
            group: sampleGroups.first.copyWith(description: longDescription),
            items: sampleEntries,
            busy: false,
            onEdit: () {},
            onOpenEntry: (_) {},
            onArchive: () {},
          ),
        ),
      ),
    );

    final card = tester.getRect(find.byType(GroupCard));
    final archive = tester.getRect(find.byTooltip(l10n.archive));
    expect(archive.right, lessThanOrEqualTo(card.right));
    expect(archive.bottom, lessThan(tester.view.physicalSize.height));
    final paragraph = tester.renderObject<RenderParagraph>(find.text(longDescription));
    expect(paragraph.didExceedMaxLines, isTrue);
  });

  testWidgets('every default group description shows whole on a phone', (tester) async {
    tester.view.physicalSize = const Size(375, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final draft in defaultGroups) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GroupCard(
              group: sampleGroups.first.copyWith(description: draft.description),
              items: const [],
              busy: false,
              onEdit: () {},
              onOpenEntry: (_) {},
            ),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(find.text(draft.description));
      expect(paragraph.didExceedMaxLines, isFalse, reason: draft.name);
    }
  });
}
