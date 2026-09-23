import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/groups/data/datasources/groups_local_datasource.dart';
import 'package:capture/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:capture/features/groups/data/models/group_model.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sample_workspace.dart';

/// The Notion Groups data source holding [rows].
class _Notion implements IGroupsRemoteDatasource {
  _Notion(this.rows);
  final List<GroupModel> rows;

  @override
  Future<NotionResult<List<GroupModel>>> fetch(String dataSource) async => .ok(rows);

  @override
  Future<NotionResult<GroupModel>> create(
    String dataSource, {
    required String name,
    required String description,
  }) => throw UnimplementedError();

  @override
  Future<NotionResult<void>> update(GroupModel group) => throw UnimplementedError();
}

class _Cache implements IGroupsLocalDatasource {
  List<GroupModel> rows = [];

  @override
  List<GroupModel> read() => rows;

  @override
  void write(List<GroupModel> groups) => rows = groups;
}

void main() {
  test('a Groups row with no name is skipped, not thrown', () async {
    const named = GroupModel(id: 'g1', name: 'Work', description: '');
    const unnamed = GroupModel(id: 'g2', name: ' ', description: 'Left blank in Notion');
    final repo = GroupsRepository(_Notion([named, unnamed]), _Cache());

    final refreshed = await repo.refresh(sampleWorkspace);

    expect([for (final g in refreshed.valueOrNull ?? const <Group>[]) g.id.value], equals(['g1']));
    expect([for (final g in repo.cached()) g.id.value], equals(['g1']));
  });
}
