import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/shell/presentation/models/nav_destination.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';

class _Route extends GoRouteData {
  const _Route();
}

const _destinations = [
  NavDestination(key: 'a', icon: Icons.mic_none_outlined, label: 'Capture', route: _Route()),
  NavDestination(key: 'b', icon: Icons.home_outlined, label: 'Groups', route: _Route()),
];

Future<void> _pump(WidgetTester tester, {required int? selected}) => tester.pumpWidget(
  MaterialApp(
    theme: buildAppTheme(),
    home: Scaffold(
      bottomNavigationBar: BottomNavBar(
        destinations: _destinations,
        selected: selected,
        onSelected: (_) {},
      ),
    ),
  ),
);

Iterable<bool> _selected(WidgetTester tester) =>
    tester.widgetList<BottomNavItem>(find.byType(BottomNavItem)).map((item) => item.selected);

void main() {
  setUpAll(loadAppFonts);

  testWidgets('the destination on screen is the only one marked', (tester) async {
    await _pump(tester, selected: 1);

    expect(_selected(tester), [false, true]);
  });

  testWidgets('a page that is not a destination marks none', (tester) async {
    await _pump(tester, selected: null);

    expect(_selected(tester), [false, false]);
  });
}
