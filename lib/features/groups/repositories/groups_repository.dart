import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/groups/data/datasources/groups_local_datasource.dart';
import 'package:capture/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:capture/features/groups/data/models/group_model.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_repository.g.dart';

/// Groups live in Notion; a local copy keeps capture working offline.
abstract interface class IGroupsRepository {
  /// Cached groups, sorted by name.
  List<Group> cached();

  /// Fetches from Notion and replaces the cache.
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws);

  /// Seeds the suggested groups into an empty Groups data source.
  Future<NotionResult<List<Group>>> seedIfEmpty(NotionWorkspace ws);
  Future<NotionResult<Group>> create(NotionWorkspace ws, GroupDraft draft);
  Future<NotionResult<void>> update(Group group);
}

@Riverpod(keepAlive: true)
IGroupsRepository groupsRepository(Ref ref) => GroupsRepository(
  ref.read(groupsRemoteDatasourceProvider),
  ref.read(groupsLocalDatasourceProvider),
);

class GroupsRepository implements IGroupsRepository {
  GroupsRepository(this._remote, this._local);
  final IGroupsRemoteDatasource _remote;
  final IGroupsLocalDatasource _local;

  List<Group> _sorted(Iterable<GroupModel> models) =>
      [for (final m in models) m.toEntity()]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  List<Group> cached() => _sorted(_local.read());

  @override
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws) async =>
      switch (await _remote.fetch(ws.groups)) {
        Ok(:final value) => .ok(_cache(value)),
        Err(:final failure) => .err(failure),
      };

  List<Group> _cache(List<GroupModel> models) {
    _local.write(models);
    return _sorted(models);
  }

  @override
  Future<NotionResult<List<Group>>> seedIfEmpty(NotionWorkspace ws) async {
    final existing = await _remote.fetch(ws.groups);
    if (existing case Err(:final failure)) return .err(failure);
    if (existing case Ok(:final value) when value.isNotEmpty) return .ok(_cache(value));
    final seeded = <GroupModel>[];
    for (final g in defaultGroups) {
      switch (await _remote.create(ws.groups, name: g.name, description: g.description)) {
        case Ok(:final value):
          seeded.add(value);
        case Err(:final failure):
          return .err(failure);
      }
    }
    return .ok(_cache(seeded));
  }

  @override
  Future<NotionResult<Group>> create(NotionWorkspace ws, GroupDraft draft) async =>
      switch (await _remote.create(
        ws.groups,
        name: draft.name.trim(),
        description: draft.description.trim(),
      )) {
        Ok(:final value) => .ok(_added(value)),
        Err(:final failure) => .err(failure),
      };

  Group _added(GroupModel model) {
    _local.write([..._local.read(), model]);
    return model.toEntity();
  }

  @override
  Future<NotionResult<void>> update(Group group) async {
    final model = GroupModel.fromEntity(group);
    final result = await _remote.update(model);
    if (result is Ok) _local.write([for (final g in _local.read()) g.id == group.id ? model : g]);
    return result;
  }
}
