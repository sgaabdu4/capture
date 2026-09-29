import 'dart:io';

import 'package:capture/app/capture_app.dart';
import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_workspace_local_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/settings_screen.dart';
import 'package:capture/features/settings/repositories/settings_repository.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/app_harness.dart';
import '../helpers/sample_workspace.dart';
import '../helpers/test_fakes.dart';

class _Jev extends Mock implements IJevRemoteDatasource {}

class _Notion extends Mock implements INotionWorkspaceRemoteDatasource {}

/// Fail the first credential deletion before reset can erase any local data.
class _ResetSecrets extends FakeSecrets {
  _ResetSecrets(super.values);

  bool failDeletion = false;

  @override
  Future<void> delete(Secret secret) async {
    if (failDeletion) return Future.error(Exception('synthetic credential deletion failure'));
    await super.delete(secret);
  }
}

/// Groups whose local cache is empty until connection seeds it.
class _SeededGroups extends SampleGroups {
  List<Group> _cache = const [];

  @override
  List<Group> cached() => _cache;

  @override
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws) async => .ok(_cache);

  @override
  Future<NotionResult<List<Group>>> seedIfEmpty(NotionWorkspace ws) async =>
      .ok(_cache = sampleGroups);
}

/// Library that counts remote refreshes.
class _CountedLibrary extends SampleLibrary {
  int refreshes = 0;

  @override
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws) async {
    refreshes++;
    return super.refresh(ws);
  }
}

final _l10n = lookupAppLocalizations(const Locale('en'));
const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

Future<void> _open(WidgetTester tester, String key) async {
  final target = find.byKey(ValueKey(key));
  await tester.ensureVisible(target);
  await _settle(tester);
  await tester.tap(target);
  await _settle(tester);
}

/// Launch the real Mac app with the existing harness and endpoint overrides.
Future<ProviderContainer> _launch(WidgetTester tester, List<Override> overrides) async {
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
  return container;
}

void main() {
  late Directory support;
  late INativePlatformService native;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    await loadAppFonts();
  });
  setUp(() {
    support = .systemTemp.createTempSync('capture_settings_flow');
    native = stubNative();
  });
  tearDown(() => support.deleteSync(recursive: true));

  testWidgets('failed key replacement retains input until persisted retry succeeds', (
    tester,
  ) async {
    final secrets = FakeSecrets({.typesafeKey: 'configured-key'});
    final jev = _Jev();
    when(() => jev.validateKey('replacement-key')).thenAnswer((_) async => const .err(.invalidKey));
    final app = await _launch(tester, [
      ...appOverrides(
        support: support,
        native: native,
        fakes: (secrets: secrets, reminders: null, system: null),
      ),
      jevRemoteDatasourceProvider.overrideWithValue(jev),
    ]);
    await _open(tester, AppWidgetKeys.settingsButton);
    final field = find.byKey(const ValueKey(AppWidgetKeys.typesafeKeyField));
    final button = find.byKey(const ValueKey(AppWidgetKeys.typesafeSaveButton));
    final initial = app.read(settingsProvider);
    expect(initial.hasTypesafeKey, isTrue);
    await tester.enterText(field, 'replacement-key');

    await _open(tester, AppWidgetKeys.typesafeSaveButton);

    final rejected = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).keySavedSerial,
    );
    final rejectedStored = await secrets.read(.typesafeKey);
    expect(
      rejected,
      equals((input: 'replacement-key', busy: false, serial: initial.keySavedSerial)),
    );
    expect(rejectedStored, equals('configured-key'));
    expect(app.read(settingsProvider).keyFailure, JevFailure.invalidKey);
    when(() => jev.validateKey('replacement-key'))
        .thenThrow(Exception('synthetic validation failure'));

    await _open(tester, AppWidgetKeys.typesafeSaveButton);

    final interrupted = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).keySavedSerial,
    );
    final interruptedStored = await secrets.read(.typesafeKey);
    expect(interrupted, equals(rejected));
    expect(interruptedStored, equals(rejectedStored));
    when(() => jev.validateKey('replacement-key')).thenAnswer((_) async => const .ok(null));

    await _open(tester, AppWidgetKeys.typesafeSaveButton);

    final saved = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).keySavedSerial,
    );
    final savedStored = await secrets.read(.typesafeKey);
    expect(saved, equals((input: '', busy: false, serial: rejected.serial + 1)));
    expect(savedStored, equals('replacement-key'));
  });

  testWidgets('failed reconnect retains input until the new connection is persisted', (
    tester,
  ) async {
    final secrets = FakeSecrets({.typesafeKey: 'key', .notionToken: 'configured-token'});
    final model = NotionWorkspaceModel.fromEntity(sampleWorkspace);
    final seed = ProviderContainer.test(
      overrides: appOverrides(support: support, native: native),
    );
    seed.read(notionWorkspaceLocalDatasourceProvider).write(model);
    seed.dispose();
    final notion = _Notion();
    when(() => notion.connect(token: 'replacement-token', parentPageId: 'parent', known: model))
        .thenAnswer((_) async => const .err(.notShared));
    final app = await _launch(tester, [
      ...appOverrides(
        support: support,
        native: native,
        fakes: (secrets: secrets, reminders: null, system: null),
      ),
      notionWorkspaceRemoteDatasourceProvider.overrideWithValue(notion),
      groupsRepositoryProvider.overrideWithValue(SampleGroups()),
      libraryRepositoryProvider.overrideWithValue(SampleLibrary()),
    ]);
    await _open(tester, AppWidgetKeys.settingsButton);
    final field = find.byKey(const ValueKey(AppWidgetKeys.notionTokenField));
    final button = find.byKey(const ValueKey(AppWidgetKeys.notionConnectButton));
    final initial = app.read(settingsProvider);
    expect(initial.notionConnected, isTrue);
    await tester.enterText(field, 'replacement-token');

    await _open(tester, AppWidgetKeys.notionConnectButton);

    final rejected = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).notionConnectedSerial,
    );
    final rejectedPersisted = (
      stored: await secrets.read(.notionToken),
      workspace: app.read(settingsProvider).workspace,
      cached: app.read(notionWorkspaceLocalDatasourceProvider).read(),
    );
    expect(
      rejected,
      equals((input: 'replacement-token', busy: false, serial: initial.notionConnectedSerial)),
    );
    expect(
      rejectedPersisted,
      equals((stored: 'configured-token', workspace: sampleWorkspace, cached: model)),
    );
    expect(app.read(settingsProvider).notionFailure, NotionFailure.notShared);
    when(() => notion.connect(token: 'replacement-token', parentPageId: 'parent', known: model))
        .thenThrow(Exception('synthetic connection failure'));

    await _open(tester, AppWidgetKeys.notionConnectButton);

    final interrupted = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).notionConnectedSerial,
    );
    final interruptedPersisted = (
      stored: await secrets.read(.notionToken),
      workspace: app.read(settingsProvider).workspace,
      cached: app.read(notionWorkspaceLocalDatasourceProvider).read(),
    );
    expect(interrupted, equals(rejected));
    expect(interruptedPersisted, equals(rejectedPersisted));
    when(() => notion.connect(token: 'replacement-token', parentPageId: 'parent', known: model))
        .thenAnswer((_) async => .ok(model));

    await _open(tester, AppWidgetKeys.notionConnectButton);

    final connected = (
      input: tester.widget<TextField>(field).controller?.text,
      busy: tester.widget<InkButton>(button).busy,
      serial: app.read(settingsProvider).notionConnectedSerial,
    );
    final connectedPersisted = (
      stored: await secrets.read(.notionToken),
      workspace: app.read(settingsProvider).workspace,
      cached: app.read(notionWorkspaceLocalDatasourceProvider).read(),
    );
    expect(connected, equals((input: '', busy: false, serial: rejected.serial + 1)));
    expect(
      connectedPersisted,
      equals((stored: 'replacement-token', workspace: sampleWorkspace, cached: model)),
    );
  });

  testWidgets('completed Notion connection reloads seeded Groups and refreshes Library', (
    tester,
  ) async {
    final model = NotionWorkspaceModel.fromEntity(sampleWorkspace);
    final seed = ProviderContainer.test(
      overrides: appOverrides(support: support, native: native),
    );
    seed.read(notionWorkspaceLocalDatasourceProvider).write(model);
    seed.dispose();
    final notion = _Notion();
    when(() => notion.connect(token: 'replacement-token', parentPageId: 'parent', known: model))
        .thenAnswer((_) async => .ok(model));
    final groups = _SeededGroups();
    final library = _CountedLibrary();
    final app = await _launch(tester, [
      ...appOverrides(
        support: support,
        native: native,
        fakes: (
          secrets: FakeSecrets({.typesafeKey: 'key', .notionToken: 'configured-token'}),
          reminders: null,
          system: null,
        ),
      ),
      notionWorkspaceRemoteDatasourceProvider.overrideWithValue(notion),
      groupsRepositoryProvider.overrideWithValue(groups),
      libraryRepositoryProvider.overrideWithValue(library),
    ]);
    await _open(tester, AppWidgetKeys.settingsButton);
    final before = (groups: app.read(groupsProvider).groups, refreshes: library.refreshes);
    await tester.enterText(
      find.byKey(const ValueKey(AppWidgetKeys.notionTokenField)),
      'replacement-token',
    );

    await _open(tester, AppWidgetKeys.notionConnectButton);

    final after = (groups: app.read(groupsProvider).groups, refreshes: library.refreshes);
    expect(before.groups, isEmpty);
    expect(after.groups, orderedEquals(sampleGroups));
    expect(after.refreshes, before.refreshes + 1);
  });

  testWidgets(
    'Reset forgets keys, Notion page, captures, auto-save and reminders; keeps the model',
    (tester) async {
      final seed = ProviderContainer.test(
        overrides: appOverrides(support: support, native: native),
      );
      seed.read(captureRepositoryProvider).put(sampleProposedCapture);
      seed.read(notionWorkspaceLocalDatasourceProvider).write(.fromEntity(sampleWorkspace));
      seed.read(settingsRepositoryProvider).saveAutoSave(on: true);
      seed.dispose();
      final recording = File('${support.path}/captures/proposed.m4a')..createSync(recursive: true);
      final model = File('${support.path}/model/verified.json')..createSync(recursive: true);
      final secrets = _ResetSecrets({.typesafeKey: 'key', .notionToken: 'token'})
        ..failDeletion = true;
      final reminders = FakeReminders();
      final app = await _launch(
        tester,
        appOverrides(
          support: support,
          native: native,
          fakes: (secrets: secrets, reminders: reminders, system: null),
        ),
      );
      await _open(tester, AppWidgetKeys.navRecordings);
      expect(find.byKey(ValueKey(sampleProposedCapture.id.value)), findsOneWidget);
      await _open(tester, AppWidgetKeys.settingsButton);
      expect(find.text(_l10n.typesafeSaved), findsOneWidget);
      expect(find.text(_l10n.notionNeeded), findsNothing);

      final reset = find.byKey(const ValueKey(AppWidgetKeys.resetButton));
      await tester.scrollUntilVisible(
        reset,
        300,
        scrollable: find.descendant(
          of: find.byType(PageFrame),
          matching: find.byWidgetPredicate(
            (widget) => widget is Scrollable && widget.axisDirection == .down,
          ),
        ),
      );
      await tester.ensureVisible(reset);
      await _settle(tester);
      final previous = app.read(settingsProvider);
      final destinationSerial = app.read(captureFlowProvider).destinationSerial;
      final captureBeforeFailure = app
          .read(captureRepositoryProvider)
          .get(sampleProposedCapture.id.value);
      await _open(tester, AppWidgetKeys.resetButton);
      await _open(tester, AppWidgetKeys.resetConfirmButton);

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(app.read(settingsProvider), same(previous));
      expect(app.read(captureFlowProvider).destinationSerial, equals(destinationSerial));
      expect([
        for (final secret in Secret.values) await secrets.read(secret),
      ], equals(['key', 'token']));
      final retained = (
        recording: recording.existsSync(),
        model: model.existsSync(),
        remindersCancelled: reminders.cancelledAll,
      );
      final retainedCapture = app
          .read(captureRepositoryProvider)
          .get(sampleProposedCapture.id.value);
      expect(retained, equals((recording: true, model: true, remindersCancelled: false)));
      expect(retainedCapture, equals(captureBeforeFailure));
      secrets.failDeletion = false;
      await _open(tester, AppWidgetKeys.resetButton);
      await _open(tester, AppWidgetKeys.resetConfirmButton);

      expect([for (final s in Secret.values) await secrets.read(s)], equals([null, null]));
      expect(recording.parent.existsSync(), isFalse);
      expect(model.existsSync(), isTrue);
      expect(reminders.cancelledAll, isTrue);
      expect(app.read(settingsProvider).autoSave, isFalse);
      expect(app.read(settingsRepositoryProvider).autoSave(), isFalse);
      expect(find.text(_l10n.setupTitle), findsOneWidget);
      expect(find.text(_l10n.typesafeNeeded), findsOneWidget);
      expect(find.text(_l10n.notionNeeded), findsOneWidget);
      await _open(tester, AppWidgetKeys.navRecordings);
      expect(find.text(_l10n.emptyCaptures), findsOneWidget);
    },
  );
}
