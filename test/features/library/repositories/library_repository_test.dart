import 'dart:io';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/library/data/datasources/library_local_datasource.dart';
import 'package:capture/features/library/data/datasources/library_remote_datasource.dart';
import 'package:capture/features/library/data/models/library_entry_model.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/app_harness.dart';
import '../../../helpers/sample_workspace.dart';
import '../../../helpers/test_fakes.dart';

class _Notion implements ILibraryRemoteDatasource {
  _Notion({this.failure});
  final NotionFailure? failure;
  final pages = <String, LibraryEntryModel>{};
  final trashed = <String>[];
  String? zone;
  String bodyText = 'Old details';
  Exception? bodyException;
  String? newBody;

  NotionResult<void> get _write => switch (failure) {
    final NotionFailure f => .err(f),
    null => const .ok(null),
  };

  @override
  Future<NotionResult<List<LibraryEntryModel>>> fetch(String dataSource) async =>
      .ok([...pages.values]);

  @override
  Future<NotionResult<void>> setDone(String pageId, {required bool done}) async => _write;

  @override
  Future<NotionResult<void>> update(LibraryEntryModel entry, {required String timeZone}) async {
    if (failure == null) {
      pages[entry.pageId] = entry;
      zone = timeZone;
    }
    return _write;
  }

  @override
  Future<NotionResult<ItemBody>> body(String pageId) async {
    if (bodyException case final error?) throw error;
    return .ok((text: bodyText, blockIds: ['p1']));
  }

  @override
  Future<NotionResult<void>> replaceBody(String pageId, ItemBody old, String text) async {
    newBody = text;
    return _write;
  }

  @override
  Future<NotionResult<void>> trash(String pageId) async {
    if (failure == null) trashed.add(pageId);
    return _write;
  }
}

class _Mirror implements ILibraryLocalDatasource {
  final rows = <String, LibraryEntryModel>{};

  @override
  List<LibraryEntryModel> all() => [...rows.values];

  @override
  void put(LibraryEntryModel entry) => rows[entry.itemId] = entry;

  @override
  void remove(String itemId) => rows.remove(itemId);

  @override
  void replaceAll(List<LibraryEntryModel> entries) => rows
    ..clear()
    ..addEntries([for (final e in entries) MapEntry(e.itemId, e)]);
}

/// Every reminder call, in order, e.g. `cancel item-1`, `schedule item-1 …`.
class _Reminders implements IReminderDatasource {
  final calls = <String>[];

  @override
  Future<bool> schedule({
    required String itemId,
    required String? title,
    required tz.TZDateTime at,
  }) async {
    calls.add('schedule $itemId ${at.toUtc().toIso8601String()}');
    return true;
  }

  @override
  Future<void> cancel(String itemId) async => calls.add('cancel $itemId');

  @override
  Future<void> cancelAll() async => calls.add('cancel all');

  @override
  Future<void> show({required String id, required String title, required String body}) async {}
}

/// A saved task due tomorrow (after [FakeSystem.now]) with no reminder.
final _task = LibraryEntry(
  pageId: .new('page-1'),
  itemId: .new('item-1'),
  title: 'Call the dentist',
  kind: .task,
  groupId: .new('personal'),
  due: const .new(2026, 9, 18, hour: 9, minute: 0),
);

/// The repository over fresh fakes, with [_task] in the mirror.
class _Fixture {
  _Fixture({NotionFailure? failure}) : notion = _Notion(failure: failure);

  final _Notion notion;
  final mirror = _Mirror()..put(.fromEntity(_task));
  final reminders = _Reminders();
  late final repo = LibraryRepository(notion, mirror, reminders, FakeSystem());
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('a failed SQLite refresh keeps prior entries and can be retried', () async {
    final support = Directory.systemTemp.createTempSync('capture_library_refresh');
    addTearDown(() => support.deleteSync(recursive: true));
    final updated = _task.copyWith(title: 'Updated in Notion');
    final notion = _Notion()..pages['page-1'] = .fromEntity(updated);
    final container = ProviderContainer.test(
      overrides: [
        ...appOverrides(support: support, native: stubNative()),
        settingsProvider.overrideWithBuild(readySettings),
        libraryRemoteDatasourceProvider.overrideWithValue(notion),
      ],
    );
    final local = container.read(libraryLocalDatasourceProvider);
    local.put(.fromEntity(_task));
    final notifier = container.read(libraryProvider.notifier);
    final database = container.read(localDatabaseProvider);
    database.execute('''
      CREATE TRIGGER fail_refresh BEFORE INSERT ON library
      BEGIN SELECT RAISE(ABORT, 'synthetic cache write failure'); END;
    ''');

    await expectLater(notifier.refresh(), completes);

    final failed = container.read(libraryProvider);
    expect(failed.entries, equals([_task]));
    expect(failed.refreshing, isFalse);
    expect(failed.cacheRefreshFailed, isTrue);
    expect(failed.failure, isNull);
    expect(failed.failureSerial, equals(1));
    expect(failed.refreshedAtUtc, isNull);
    expect(local.all().map((entry) => entry.toEntity()), equals([_task]));

    database.execute('DROP TRIGGER fail_refresh');
    await notifier.refresh();

    final retried = container.read(libraryProvider);
    expect(retried.entries, equals([updated]));
    expect(retried.refreshing, isFalse);
    expect(retried.cacheRefreshFailed, isFalse);
    expect(retried.refreshedAtUtc, equals(FakeSystem.now));
  });

  test('an unexpected body-read failure preserves the library and can be retried', () async {
    final fixture = _Fixture();
    fixture.notion.bodyException = Exception('synthetic body read failure');
    final container = ProviderContainer.test(
      overrides: [libraryRepositoryProvider.overrideWithValue(fixture.repo)],
    );
    final notifier = container.read(libraryProvider.notifier);
    final previous = container.read(libraryProvider);

    await expectLater(notifier.body(_task), completion(isNull));

    expect(container.read(libraryProvider), same(previous));
    expect(fixture.repo.cached(), equals([_task]));
    fixture.notion.bodyException = null;

    expect(await notifier.body(_task), equals('Old details'));
  });

  test('an edit reaches Notion and the mirror, and the reminder is rescheduled', () async {
    final _Fixture(:repo, :notion, :mirror, :reminders) = _Fixture();
    final edited = _task.copyWith(
      title: 'Call the dentist about the filling',
      due: const .new(2026, 9, 18, hour: 10, minute: 30),
      reminder: const .new(2026, 9, 18, hour: 10, minute: 30),
    );

    final result = await repo.update(edited);

    expect(result, isA<Ok<LibraryEntry, NotionFailure>>());
    expect(notion.pages['page-1']?.toEntity(), equals(edited));
    expect(notion.zone, equals(FakeSystem.zone));
    expect(mirror.rows['item-1']?.toEntity(), equals(edited));
    // 10:30 in London (BST) is 09:30 UTC.
    expect(reminders.calls, equals(['cancel item-1', 'schedule item-1 2026-09-18T09:30:00.000Z']));
  });

  test('turning a reminder off cancels it without scheduling another', () async {
    final _Fixture(:repo, :reminders) = _Fixture();

    await repo.update(_task.copyWith(reminder: null));

    expect(reminders.calls, equals(['cancel item-1']));
  });

  test('changed details replace the page body; unchanged details are left alone', () async {
    final changed = _Fixture();
    await changed.repo.update(_task, body: 'New details');
    final same = _Fixture();
    await same.repo.update(_task, body: 'Old details');

    expect(changed.notion.newBody, equals('New details'));
    expect(same.notion.newBody, isNull);
  });

  test('when Notion refuses an edit, the mirror and reminders are untouched', () async {
    final _Fixture(:repo, :mirror, :reminders) = _Fixture(failure: .unavailable);

    final result = await repo.update(_task.copyWith(title: 'Changed'));

    expect(result, isA<Err<LibraryEntry, NotionFailure>>());
    expect(mirror.rows['item-1']?.title, equals('Call the dentist'));
    expect(reminders.calls, isEmpty);
  });

  test('deleting trashes the Notion page, drops the mirror row and cancels the reminder', () async {
    final _Fixture(:repo, :notion, :mirror, :reminders) = _Fixture();

    await repo.delete(_task);

    expect(notion.trashed, equals(['page-1']));
    expect(mirror.rows, isEmpty);
    expect(reminders.calls, equals(['cancel item-1']));
  });

  test('a page made in Notion without an Item ID is skipped, not thrown', () async {
    final _Fixture(:repo, :notion) = _Fixture();
    notion.pages['page-1'] = .fromEntity(_task);
    notion.pages['page-2'] = const .new(
      pageId: 'page-2',
      itemId: '',
      title: 'Typed straight into Notion',
      kind: .task,
    );

    final refreshed = await repo.refresh(sampleWorkspace);

    expect(refreshed.valueOrNull, equals([_task]));
    expect(repo.cached(), equals([_task]));
  });

  test('when Notion refuses a delete, the entry stays', () async {
    final _Fixture(:repo, :mirror, :reminders) = _Fixture(failure: .unavailable);

    await repo.delete(_task);

    expect(mirror.rows.keys, equals(['item-1']));
    expect(reminders.calls, isEmpty);
  });
}
