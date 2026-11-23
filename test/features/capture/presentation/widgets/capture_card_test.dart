import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/widgets/capture_card.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/sample_workspace.dart';
import '../../../../helpers/test_fakes.dart';

void _noop() {}

Future<void> _pump(WidgetTester tester, {CaptureRecord? record}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CaptureCard(
          record: record ?? sampleProposedCapture,
          nowUtc: FakeSystem.now,
          busy: false,
          idle: true,
          onRetry: _noop,
          onReview: _noop,
          onRetrySave: _noop,
          onReviewAgain: _noop,
          onDelete: _noop,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('the one action that moves a capture on is a filled button', (tester) async {
    await _pump(tester);

    final review = tester.widget<InkButton>(
      find.byKey(const ValueKey(AppWidgetKeys.captureReviewButton)),
    );
    expect(review.onPressed, isNotNull);
  });

  testWidgets('the actions line up with the status text, directly under the details', (
    tester,
  ) async {
    await _pump(tester);

    final status = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.captureStatus)));
    final actions = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.captureActions)));
    expect(actions.dx, status.dx);
    expect(actions.dy, greaterThan(status.dy));
  });

  testWidgets('a saved capture offers Delete as text that starts at the status edge', (
    tester,
  ) async {
    await _pump(tester, record: sampleSavedCapture);

    final status = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.captureStatus)));
    final delete = tester.getTopLeft(find.text('Delete'));
    expect(delete.dx, status.dx);
  });

  testWidgets('the expand arrow sits in the leading slot, before the status', (tester) async {
    await _pump(tester);

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.leading, isNotNull);
    expect(tile.trailing, isNull);
  });

  testWidgets('the status and its time share a line when the card is wide', (tester) async {
    tester.view.physicalSize = const Size(1240, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CaptureCard(
            record: sampleSavedCapture,
            nowUtc: FakeSystem.now,
            busy: false,
            idle: true,
            onRetry: _noop,
            onReview: _noop,
            onRetrySave: _noop,
            onReviewAgain: _noop,
            onDelete: _noop,
          ),
        ),
      ),
    );

    final status = tester.getTopLeft(find.byKey(const ValueKey(AppWidgetKeys.captureStatus)));
    final meta = tester.getTopLeft(find.text('20 minutes ago · 0:14'));
    expect(meta.dy, closeTo(status.dy, 6));
  });
}
