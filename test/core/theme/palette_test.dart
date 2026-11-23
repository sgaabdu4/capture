import 'package:capture/core/theme/palette.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

double _contrast(Color a, Color b) {
  final (:light, :dark) = a.computeLuminance() > b.computeLuminance()
      ? (light: a.computeLuminance(), dark: b.computeLuminance())
      : (light: b.computeLuminance(), dark: a.computeLuminance());
  return (light + 0.05) / (dark + 0.05);
}

void main() {
  test('the ready tick has 3 to 1 contrast against the card', () {
    expect(_contrast(Palette.ok, Palette.card), greaterThanOrEqualTo(3));
  });
}
