import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/sample_workspace.dart';
import '../../../../helpers/test_fakes.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('two captures of the same age and length differ by their status', () {
    final saved = sampleSavedCapture.identity(l10n, FakeSystem.now);
    final waiting = sampleProposedCapture.identity(l10n, FakeSystem.now);

    expect(saved, 'Saved to Notion · 20 minutes ago · 0:14');
    expect(waiting, isNot(saved));
  });
}
