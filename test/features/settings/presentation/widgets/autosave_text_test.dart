import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('the auto-save explanation fits in two short sentences', () {
    final detail = lookupAppLocalizations(const Locale('en')).autoSaveDetail;

    expect(detail.split(' ').length, lessThanOrEqualTo(20));
  });
}
