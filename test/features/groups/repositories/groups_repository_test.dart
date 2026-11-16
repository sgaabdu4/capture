import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/groups/data/datasources/groups_local_datasource.dart';
import 'package:capture/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:capture/features/groups/data/models/group_model.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sample_workspace.dart';

/// The Notion Groups data source holding [rows].
class _Notion implements IGroupsRemoteDatasource {
  _Notion(this.rows, {this.createsLeft = 0, this.fetchFails = false});
  final List<GroupModel> rows;
  final bool fetchFails;
  int createsLeft;
  final created = <String>[];

  @override
  Future<NotionResult<List<GroupModel>>> fetch(String dataSource) async =>
      fetchFails ? const .err(.network) : .ok(rows);

  @override
  Future<NotionResult<GroupModel>> create(
    String dataSource, {
    required String name,
    required String description,
  }) async {
    if (createsLeft == 0) return const .err(.invalidRequest);
    createsLeft--;
    created.add(name);
    return .ok(GroupModel(id: 'made-${created.length}', name: name, description: description));
  }

  @override
  Future<NotionResult<void>> update(GroupModel group) async => const .ok(null);
}

class _Cache implements IGroupsLocalDatasource {
  List<GroupModel> rows = [];

  @override
  List<GroupModel> read() => rows;

  @override
  void write(List<GroupModel> groups) => rows = groups;
}

Matcher _failedWith(NotionFailure expected) =>
    isA<Err<List<Group>, NotionFailure>>().having((e) => e.failure, 'failure', expected);

void main() {
  test('a Groups row with no name is skipped, not thrown', () async {
    const named = GroupModel(id: 'g1', name: 'Work', description: '');
    const unnamed = GroupModel(id: 'g2', name: ' ', description: 'Left blank in Notion');
    final repo = GroupsRepository(_Notion([named, unnamed]), _Cache());

    final refreshed = await repo.refresh(sampleWorkspace);

    expect([for (final g in refreshed.valueOrNull ?? const <Group>[]) g.id.value], equals(['g1']));
    expect([for (final g in repo.cached()) g.id.value], equals(['g1']));
  });

  group('seeding an empty Groups data source', () {
    test('groups already in Notion are kept and nothing is created', () async {
      const named = GroupModel(id: 'g1', name: 'Work', description: '');
      final notion = _Notion([named]);
      final cache = _Cache();
      final repo = GroupsRepository(notion, cache);

      final seeded = await repo.seedIfEmpty(sampleWorkspace);

      expect([for (final g in seeded.valueOrNull ?? const <Group>[]) g.id.value], equals(['g1']));
      expect(notion.created, isEmpty);
      expect(cache.rows, equals([named]));
    });

    test('an empty data source gets every suggested group', () async {
      final notion = _Notion([], createsLeft: defaultGroups.length);
      final cache = _Cache();
      final repo = GroupsRepository(notion, cache);

      final seeded = await repo.seedIfEmpty(sampleWorkspace);

      expect(notion.created, equals([for (final g in defaultGroups) g.name]));
      expect(seeded.valueOrNull?.length, equals(defaultGroups.length));
      expect(cache.rows.length, equals(defaultGroups.length));
    });

    test('a refused create stops the seeding and caches nothing', () async {
      final notion = _Notion([], createsLeft: 1);
      final cache = _Cache();
      final repo = GroupsRepository(notion, cache);

      final seeded = await repo.seedIfEmpty(sampleWorkspace);

      expect(seeded, _failedWith(.invalidRequest));
      expect(cache.rows, isEmpty);
    });

    test('a failed read is returned as it is', () async {
      final repo = GroupsRepository(_Notion([], fetchFails: true), _Cache());

      final seeded = await repo.seedIfEmpty(sampleWorkspace);

      expect(seeded, _failedWith(.network));
    });
  });
}
