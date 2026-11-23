import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/features/groups/presentation/widgets/group_list.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/sample_workspace.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('a group card keeps its text and actions close on a wide screen', (tester) async {
    tester.view.physicalSize = const Size(1280, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GroupList(
            activeGroups: sampleGroups,
            archivedGroups: const [],
            entries: sampleEntries,
            busy: false,
            onEdit: (_) {},
            onOpenEntry: (_) {},
            onArchive: (_) {},
            onRestore: (_) {},
          ),
        ),
      ),
    );

    final card = tester.getRect(
      find.byKey(ValueKey(AppWidgetKeys.groupCard(sampleGroups.first.id.value))),
    );
    expect(card.width, Sizes.groupCardWidth);
    expect(card.left, 0);
  });

  testWidgets('a group card fills a phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GroupList(
            activeGroups: sampleGroups,
            archivedGroups: const [],
            entries: sampleEntries,
            busy: false,
            onEdit: (_) {},
            onOpenEntry: (_) {},
            onArchive: (_) {},
            onRestore: (_) {},
          ),
        ),
      ),
    );

    expect(
      tester
          .getSize(find.byKey(ValueKey(AppWidgetKeys.groupCard(sampleGroups.first.id.value))))
          .width,
      390,
    );
  });
}
