import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/settings/presentation/widgets/model_step.dart';
import 'package:capture/features/settings/presentation/widgets/privacy_section.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

const _longestLine = 20;

Widget _host(Widget child) => MaterialApp(
  theme: buildAppTheme(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  setUpAll(loadAppFonts);
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('the speech model credit is short enough to read in one glance', () {
    expect(l10n.modelAttribution.split(' ').length, lessThanOrEqualTo(_longestLine));
    expect(l10n.phoneModelAttribution.split(' ').length, lessThanOrEqualTo(_longestLine));
  });

  testWidgets('the credit sits in Privacy, not under the Speech model heading', (tester) async {
    await tester.pumpWidget(
      _host(ModelStep(ready: true, download: null, totalBytes: 1, onDownload: () {})),
    );
    expect(find.text(l10n.modelAttribution), findsNothing);

    await tester.pumpWidget(_host(const PrivacySection()));
    expect(find.text(l10n.modelAttribution), findsOneWidget);
  });
}
