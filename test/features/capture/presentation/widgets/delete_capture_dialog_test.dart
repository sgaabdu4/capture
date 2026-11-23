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
}
