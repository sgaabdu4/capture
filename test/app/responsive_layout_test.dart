import 'dart:io';
import 'dart:math';

import 'package:capture/app/app_startup.dart';
import 'package:capture/app/capture_app.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/features/capture/presentation/widgets/source_word.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/widgets/notion_guide_dialog.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/app_harness.dart';
import '../helpers/sample_workspace.dart';

final _l10n = lookupAppLocalizations(const .new('en'));

/// Window widths from a small phone to a 4K display, in logical pixels.
const _widths = [320.0, 375.0, 480.0, 600.0, 768.0, 1024.0, 1280.0, 1920.0, 2560.0, 3840.0];
const _widest = 3840.0;

/// Phone-sized windows are also short.
double _height(double width) => width < 600 ? 700 : 1000;

/// Each page by name, and how to open it.
final Map<String, void Function(BuildContext)> _pages = {
  'home': const HomeRoute().go,
  'groups': const GroupsRoute().go,
  'recordings': const RecordingsRoute().go,
  'review editor': const EditorRoute(recordId: 'proposed').go,
  'to-do': const TodoRoute().go,
  'upcoming': const UpcomingRoute().go,
  'settings': const SettingsRoute().go,
};

/// Every word the review card shows from the sample transcript.
final Set<String> _transcriptWords = {
  for (final item in sampleProposedCapture.items)
    for (final span in item.sources) ...span.excerpt.value.split(' '),
};

/// One-glyph transcript nodes lack measurable pixels under Linux anti-aliasing; check their colours directly.
class _TextContrast extends MinimumTextContrastGuideline {
  const _TextContrast();

  @override
  bool shouldSkipNode(SemanticsData data) =>
      super.shouldSkipNode(data) || _transcriptWords.contains(data.label);
}

/// WCAG contrast of [text] on [background].
double _contrast(Color text, Color background) {
  final (x: a, y: b) = (x: text.computeLuminance(), y: background.computeLuminance());
  return (max(a, b) + 0.05) / (min(a, b) + 0.05);
}

const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

/// Every overflow or layout error thrown since the last call, labelled.
List<String> _layoutErrors(WidgetTester tester, String where, double width) => [
  for (Object? error = tester.takeException(); error != null; error = tester.takeException())
    '$where @ ${width.toInt()}: ${'$error'.split('\n').firstOrNull ?? ''}',
];

Future<void> _resize(WidgetTester tester, double width) async {
  tester.view.physicalSize = .new(width, _height(width));
  await _settle(tester);
}

/// A context inside the router, for typed navigation.
BuildContext _shell(WidgetTester tester) =>
    tester.element(find.byKey(const ValueKey(AppWidgetKeys.settingsButton)));

Future<void> _go(WidgetTester tester, void Function(BuildContext) open) async {
  open(_shell(tester));
  await _settle(tester);
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.tap(target);
  await _settle(tester);
}

Future<void> _launch(
  WidgetTester tester,
  Directory support, {
  required bool ready,
  bool samples = true,
  Size? viewport,
}) async {
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer.test(
    overrides: [
      ...appOverrides(support: support, native: stubNative()),
      if (ready) ...[
        settingsProvider.overrideWithBuild(readySettings),
        appStartupProvider.overrideWith((ref) async {}),
      ],
      if (samples) ...[
        groupsRepositoryProvider.overrideWithValue(SampleGroups()),
        libraryRepositoryProvider.overrideWithValue(SampleLibrary()),
      ],
    ],
  );
  addTearDown(container.dispose);
  if (ready) {
    container.read(captureRepositoryProvider)
      ..put(sampleSavedCapture)
      ..put(sampleProposedCapture);
  }
  if (viewport case final size?) {
    tester.view.physicalSize = size;
  } else {
    await _resize(tester, _widest);
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const CaptureApp()),
  );
  await _settle(tester);
}

Finder _within(String key, Finder matching) =>
    find.descendant(of: find.byKey(ValueKey(key)), matching: matching);

void main() {
  late Directory support;

  setUpAll(() async {
    registerFallbackValue(Duration.zero);
    tzdata.initializeTimeZones();
    await loadAppFonts();
  });
  setUp(() => support = .systemTemp.createTempSync('capture_responsive'));
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('every page lays out without overflow from a small phone to a 4K screen', (
    tester,
  ) async {
    await _launch(tester, support, ready: true);
    final errors = <String>[];
    for (final MapEntry(key: page, value: open) in _pages.entries) {
      await _go(tester, open);
      for (final width in _widths) {
        await _resize(tester, width);
        errors.addAll(_layoutErrors(tester, page, width));
      }
    }

    expect(errors, isEmpty);
  });

  testWidgets('the edit dialog and opened cards fit from a small phone to a 4K screen', (
    tester,
  ) async {
    await _launch(tester, support, ready: true);
    final errors = <String>[];
    for (final width in _widths) {
      await _resize(tester, width);
      await _go(tester, const TodoRoute().go);
      await _tap(tester, find.text(sampleTaskTitle));
      errors.addAll(_layoutErrors(tester, 'edit dialog', width));
      await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.entryCancelButton)));

      await _go(tester, const GroupsRoute().go);
      await _tap(tester, _within('ideas', find.text('Ideas')));
      errors.addAll(_layoutErrors(tester, 'opened group', width));

      await _go(tester, const RecordingsRoute().go);
      await _tap(tester, _within('saved', find.byType(ListTile)));
      errors.addAll(_layoutErrors(tester, 'opened recording', width));
    }

    expect(errors, isEmpty);
  });

  testWidgets('every page keeps its text readable on a phone and on the Mac', (tester) async {
    final semantics = tester.ensureSemantics();
    await _launch(tester, support, ready: true);
    final failures = <String>[];
    for (final width in [390.0, referenceWindow.width]) {
      await _resize(tester, width);
      for (final MapEntry(key: page, value: open) in _pages.entries) {
        await _go(tester, open);
        final result = await const _TextContrast().evaluate(tester);
        if (!result.passed) failures.add('$page @ ${width.toInt()}: ${result.reason ?? ''}');
      }
    }
    semantics.dispose();
    await _go(tester, const EditorRoute(recordId: 'proposed').go);
    final words = find.descendant(of: find.byType(SourceWord), matching: find.byType(Text));
    for (final word in words.evaluate()) {
      if (word.widget case Text(:final style)) {
        final color = DefaultTextStyle.of(word).style.merge(style).color;
        final ratio = _contrast(color ?? Colors.transparent, word.paper.card);
        if (ratio < 4.5) failures.add('transcript word: ${ratio.toStringAsFixed(2)}');
      }
    }

    expect(words, findsWidgets);
    expect(failures, isEmpty);
  });

  testWidgets('each page shows its truthful empty state', (tester) async {
    await _launch(tester, support, ready: false, samples: false, viewport: referenceWindow);

    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.navGroups)));
    expect(find.text(_l10n.groupsNeedNotion), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.navRecordings)));
    expect(find.text(_l10n.emptyCaptures), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.navTodo)));
    expect(find.text(_l10n.emptyOpenTasks), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.navUpcoming)));
    expect(find.text(_l10n.emptyUpcoming), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.settingsButton)));
    expect(find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField)), findsOneWidget);
  });

  testWidgets('the Notion step shows a picture for every setup step', (tester) async {
    await _launch(tester, support, ready: false, samples: false, viewport: referenceWindow);

    await tester.ensureVisible(find.byKey(const ValueKey(AppWidgetKeys.notionGuideButton)));
    await _tap(tester, find.byKey(const ValueKey(AppWidgetKeys.notionGuideButton)));

    expect(find.text(_l10n.notionGuideTitle), findsOneWidget);
    final steps = [
      _l10n.notionGuideStep1,
      _l10n.notionGuideStep2,
      _l10n.notionGuideStep3,
      _l10n.notionGuideStep4,
      _l10n.notionGuideStep5,
      _l10n.notionGuideStep6,
    ];
    for (final (index, text) in steps.indexed) {
      final step = find.byKey(ValueKey(AppWidgetKeys.notionGuideStep(index + 1)));
      await tester.scrollUntilVisible(
        step,
        300,
        scrollable: find.descendant(
          of: find.byType(NotionGuideDialog),
          matching: find.byWidgetPredicate(
            (widget) => widget is Scrollable && widget.axisDirection == .down,
          ),
        ),
      );
      expect(
        find.descendant(of: step, matching: find.text(_l10n.numberedStep(index + 1, text))),
        findsOneWidget,
      );
      expect(find.descendant(of: step, matching: find.byType(Image)), findsOneWidget);
    }
    await tester.tap(find.text(_l10n.close));
    await _settle(tester);
    expect(find.text(_l10n.notionGuideTitle), findsNothing);
  });

  testWidgets('setup lays out without overflow from a small phone to a 4K screen', (tester) async {
    await _launch(tester, support, ready: false);
    final errors = <String>[];
    for (final width in _widths) {
      await _resize(tester, width);
      errors.addAll(_layoutErrors(tester, 'setup', width));
    }

    expect(errors, isEmpty);
  });
}
