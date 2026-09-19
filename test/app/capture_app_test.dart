import 'dart:async';
import 'dart:io';

import 'package:capture/app/capture_app.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_workspace_local_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/shell/presentation/widgets/update_link.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_harness.dart';
import '../helpers/sample_workspace.dart';
import '../helpers/test_fakes.dart';

final _l10n = lookupAppLocalizations(const .new('en'));

/// Frame step and upper bound while waiting for the UI to settle.
const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

/// Launches the real app on the fakes in [appOverrides], plus [overrides].
Future<void> _launch(
  WidgetTester tester, {
  required Directory support,
  required INativePlatformService native,
  List<Override> overrides = const [],
}) => _pump(tester, [...appOverrides(support: support, native: native), ...overrides]);

/// Launches the real app with exactly [overrides].
Future<void> _pump(WidgetTester tester, List<Override> overrides) async {
  tester.view
    ..physicalSize = referenceWindow
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer.test(overrides: overrides);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const CaptureApp()),
  );
  await _settle(tester);
}

Future<void> _open(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await _settle(tester);
}

/// Carbon flags for ⌃⌘ and the Carbon code of K.
const _controlCommand = 0x1100;
const _carbonK = 40;

/// Opens Settings, records the keys [press] sends, and leaves them unsaved.
Future<void> _recordShortcut(
  WidgetTester tester,
  AsyncCallback press, {
  required Directory support,
  required INativePlatformService native,
}) async {
  await _launch(tester, support: support, native: native);
  await _open(tester, AppWidgetKeys.settingsButton);
  await tester.ensureVisible(find.byKey(const ValueKey(AppWidgetKeys.shortcutChangeButton)));
  await _settle(tester);
  await _open(tester, AppWidgetKeys.shortcutChangeButton);
  await press();
  await _settle(tester);
}

/// Saved entries as last synced; edits are recorded instead of sent.
class _Library implements ILibraryRepository {
  final updates = <LibraryEntry>[];

  @override
  List<LibraryEntry> cached() => const [
    .new(pageId: 'p1', itemId: 'i1', title: 'Buy oat milk', kind: .task),
    .new(pageId: 'p2', itemId: 'i2', title: 'Milk frother idea', kind: .note),
    .new(pageId: 'p3', itemId: 'i3', title: 'Call the dentist', kind: .task),
  ];

  @override
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws) async => .ok(cached());

  @override
  Future<NotionResult<LibraryEntry>> setDone(LibraryEntry entry, {required bool done}) async =>
      .ok(entry.copyWith(done: done));

  @override
  Future<NotionResult<String>> body(LibraryEntry entry) async => const .ok('');

  @override
  Future<NotionResult<LibraryEntry>> update(LibraryEntry entry, {String? body}) async {
    updates.add(entry);
    return .ok(entry);
  }

  @override
  Future<NotionResult<void>> delete(LibraryEntry entry) async => const .ok(null);
}

void main() {
  late Directory support;
  late INativePlatformService native;

  setUpAll(() async {
    registerFallbackValue(Duration.zero);
    await loadAppFonts();
  });
  setUp(() {
    support = .systemTemp.createTempSync('capture_app_test');
    native = stubNative();
  });
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('first launch shows the setup steps and does not record', (tester) async {
    await _launch(tester, support: support, native: native);

    expect(find.text(_l10n.setupTitle), findsOneWidget);
    await _open(tester, AppWidgetKeys.recordButton);
    verifyNever(() => native.startRecording(any(), limit: any(named: 'limit')));
    verify(native.installMenu).called(1);
  });

  testWidgets('the update link appears only once Sparkle finds a newer release, and opens it', (
    tester,
  ) async {
    final events = StreamController<NativeEvent>.broadcast();
    addTearDown(events.close);
    when(() => native.events).thenAnswer((_) => events.stream);
    when(native.checkForUpdates).thenAnswer((_) async {});
    await _launch(tester, support: support, native: native);
    expect(find.byType(UpdateLink), findsNothing);

    events.add(const UpdateAvailable());
    await _settle(tester);
    await tester.tap(find.text(_l10n.updateDownloadNow));
    verify(native.checkForUpdates).called(1);
  });

  testWidgets('each page shows its truthful empty state', (tester) async {
    await _launch(tester, support: support, native: native);

    await _open(tester, AppWidgetKeys.navGroups);
    expect(find.text(_l10n.groupsNeedNotion), findsOneWidget);
    await _open(tester, AppWidgetKeys.navRecordings);
    expect(find.text(_l10n.emptyCaptures), findsOneWidget);
    await _open(tester, AppWidgetKeys.navTodo);
    expect(find.text(_l10n.emptyOpenTasks), findsOneWidget);
    await _open(tester, AppWidgetKeys.navUpcoming);
    expect(find.text(_l10n.emptyUpcoming), findsOneWidget);
    await _open(tester, AppWidgetKeys.settingsButton);
    expect(find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField)), findsOneWidget);
  });

  testWidgets('the Notion step shows a picture for every setup step', (tester) async {
    await _launch(tester, support: support, native: native);

    await tester.ensureVisible(find.byKey(const ValueKey(AppWidgetKeys.notionGuideButton)));
    await _open(tester, AppWidgetKeys.notionGuideButton);

    expect(find.text(_l10n.notionGuideTitle), findsOneWidget);
    expect(find.textContaining(_l10n.notionGuideStep6), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(6));
    await tester.tap(find.text(_l10n.close));
    await _settle(tester);
    expect(find.text(_l10n.notionGuideTitle), findsNothing);
  });

  testWidgets('To-do search finds a saved note by title and saves an edit to it', (tester) async {
    final library = _Library();
    await _launch(
      tester,
      support: support,
      native: native,
      overrides: [libraryRepositoryProvider.overrideWithValue(library)],
    );
    await _open(tester, AppWidgetKeys.navTodo);

    await tester.enterText(find.byKey(const ValueKey(AppWidgetKeys.searchField)), 'MILK');
    await _settle(tester);
    expect(find.text('Buy oat milk'), findsOneWidget);
    expect(find.text('Milk frother idea'), findsOneWidget);
    expect(find.text('Call the dentist'), findsNothing);

    await tester.tap(find.text('Milk frother idea'));
    await _settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey(AppWidgetKeys.entryTitleField)),
      'Milk frother for the café',
    );
    await _open(tester, AppWidgetKeys.entrySaveButton);

    expect([for (final e in library.updates) e.title], equals(['Milk frother for the café']));
    expect(find.text('Milk frother for the café'), findsOneWidget);
  });

  testWidgets('Reset forgets keys, Notion page, captures and reminders but keeps the model', (
    tester,
  ) async {
    final seed = ProviderContainer.test(
      overrides: appOverrides(support: support, native: native),
    );
    seed.read(captureRepositoryProvider).put(sampleProposedCapture);
    seed.read(notionWorkspaceLocalDatasourceProvider).write(.fromEntity(sampleWorkspace));
    seed.dispose();
    final recording = File('${support.path}/captures/proposed.m4a')..createSync(recursive: true);
    final model = File('${support.path}/model/verified.json')..createSync(recursive: true);
    final secrets = FakeSecrets({.typesafeKey: 'key', .notionToken: 'token'});
    final reminders = FakeReminders();
    await _pump(
      tester,
      appOverrides(support: support, native: native, secrets: secrets, reminders: reminders),
    );
    await _open(tester, AppWidgetKeys.navRecordings);
    expect(find.byKey(ValueKey(sampleProposedCapture.id)), findsOneWidget);
    await _open(tester, AppWidgetKeys.settingsButton);
    expect(find.text(_l10n.typesafeSaved), findsOneWidget);
    expect(find.text(_l10n.notionNeeded), findsNothing);

    final reset = find.byKey(const ValueKey(AppWidgetKeys.resetButton));
    await tester.scrollUntilVisible(
      reset,
      300,
      scrollable: find
          .descendant(of: find.byType(PageFrame), matching: find.byType(Scrollable))
          .first,
    );
    await tester.ensureVisible(reset);
    await _settle(tester);
    await _open(tester, AppWidgetKeys.resetButton);
    await _open(tester, AppWidgetKeys.resetConfirmButton);

    expect([for (final s in Secret.values) await secrets.read(s)], equals([null, null]));
    expect(recording.parent.existsSync(), isFalse);
    expect(model.existsSync(), isTrue);
    expect(reminders.cancelledAll, isTrue);
    expect(find.text(_l10n.setupTitle), findsOneWidget);
    expect(find.text(_l10n.typesafeNeeded), findsOneWidget);
    expect(find.text(_l10n.notionNeeded), findsOneWidget);
    await _open(tester, AppWidgetKeys.navRecordings);
    expect(find.text(_l10n.emptyCaptures), findsOneWidget);
  });

  group('recording a new shortcut', () {
    testWidgets('modifiers pressed alone become the shortcut only once saved', (tester) async {
      await _recordShortcut(tester, support: support, native: native, () async {
        await tester.sendKeyDownEvent(.controlLeft);
        await tester.sendKeyDownEvent(.metaLeft);
        await tester.sendKeyUpEvent(.metaLeft);
        await tester.sendKeyUpEvent(.controlLeft);
      });

      expect(find.text('⌃⌘'), findsOneWidget);
      verify(() => native.pauseHotKey(paused: true)).called(1);
      verifyNever(() => native.setHotKey(keyCode: null, modifiers: _controlCommand, label: '⌃⌘'));
      await _open(tester, AppWidgetKeys.shortcutSaveButton);
      verify(() => native.setHotKey(keyCode: null, modifiers: _controlCommand, label: '⌃⌘'))
          .called(1);
    });

    testWidgets('a letter with modifiers becomes the shortcut once saved', (tester) async {
      await _recordShortcut(tester, support: support, native: native, () async {
        await tester.sendKeyDownEvent(.controlLeft);
        await tester.sendKeyDownEvent(.metaLeft);
        await tester.sendKeyEvent(.keyK);
      });
      await tester.sendKeyUpEvent(.metaLeft);
      await tester.sendKeyUpEvent(.controlLeft);

      expect(find.text('⌃⌘K'), findsOneWidget);
      await _open(tester, AppWidgetKeys.shortcutSaveButton);
      verify(() => native.setHotKey(keyCode: _carbonK, modifiers: _controlCommand, label: '⌃⌘K'))
          .called(1);
    });
  });
}
