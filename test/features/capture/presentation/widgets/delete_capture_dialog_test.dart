import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/capture/presentation/widgets/delete_capture_dialog.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void _noop() {}

void main() {
  testWidgets('the dialog names the recording by its age and length', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Center(
          child: DeleteCaptureDialog(
            saved: true,
            detail: '20 minutes ago · 0:14',
            onCancel: _noop,
            onDelete: _noop,
          ),
        ),
      ),
    );

    expect(find.text('20 minutes ago · 0:14'), findsOneWidget);
  });

  testWidgets('the dialog is only as tall as its text and buttons', (tester) async {
    tester.view.physicalSize = const Size(1280, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Center(
          child: DeleteCaptureDialog(
            saved: true,
            detail: '20 minutes ago · 0:14',
            onCancel: _noop,
            onDelete: _noop,
          ),
        ),
      ),
    );

    final top = tester.getTopLeft(find.text('Delete this recording?')).dy;
    final bottom = tester
        .getBottomLeft(find.byKey(const ValueKey(AppWidgetKeys.deleteConfirmButton)))
        .dy;
    expect(bottom - top, lessThan(350));
  });

  testWidgets('the buttons start at the same left edge as the title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Center(
          child: DeleteCaptureDialog(
            saved: true,
            detail: '20 minutes ago · 0:14',
            onCancel: _noop,
            onDelete: _noop,
          ),
        ),
      ),
    );

    final title = tester.getTopLeft(find.text('Delete this recording?')).dx;
    final cancel = tester.getTopLeft(find.text('Cancel')).dx;
    expect(cancel, title);
  });
}
