import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/l10n/app_localizations.g.dart';
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
}
