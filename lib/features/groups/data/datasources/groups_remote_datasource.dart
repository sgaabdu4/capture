import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/data/notion/notion_query.dart';
import 'package:capture/core/data/notion/notion_schema.dart';
import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/groups/data/models/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_remote_datasource.g.dart';

/// The Groups data source in Notion (the source of truth for groups).
abstract interface class IGroupsRemoteDatasource {
  Future<NotionResult<List<GroupModel>>> fetch(String dataSource);
  Future<NotionResult<GroupModel>> create(
    String dataSource, {
    required String name,
    required String description,
  });
  Future<NotionResult<void>> update(GroupModel group);
}

class GroupsRemoteDatasource implements IGroupsRemoteDatasource {
  GroupsRemoteDatasource(this._http);
  final INotionHttpService _http;

  @override
  Future<NotionResult<List<GroupModel>>> fetch(String dataSource) async =>
      switch (await queryAll(_http, dataSource)) {
        Ok(:final value) => .ok([
          for (final page in value)
            if (idOf(page) case final String id)
              GroupModel(
                id: id,
                name: propText(page, P.name),
                description: propText(page, P.description),
                archived: propSelect(page, P.status) == NotionValues.archived,
              ),
        ]),
        Err(:final failure) => .err(failure),
      };

  @override
  Future<NotionResult<GroupModel>> create(
    String dataSource, {
    required String name,
    required String description,
  }) async => switch (createdId(
    await _http.post('/v1/pages', {
      NotionKeys.parent: {NotionKeys.type: 'data_source_id', NotionKeys.dataSourceId: dataSource},
      NotionKeys.properties: {
        P.name: titleValue(name),
        P.description: textValue(description),
        P.status: selectValue(NotionValues.active),
      },
    }),
  )) {
    Ok(:final value) => .ok(.new(id: value, name: name, description: description)),
    Err(:final failure) => .err(failure),
  };

  @override
  Future<NotionResult<void>> update(GroupModel group) async => doneWith(
    await _http.patch('/v1/pages/${group.id}', {
      NotionKeys.properties: {
        P.name: titleValue(group.name),
        P.description: textValue(group.description),
        P.status: selectValue(group.archived ? NotionValues.archived : NotionValues.active),
      },
    }),
  );
}

@Riverpod(keepAlive: true)
IGroupsRemoteDatasource groupsRemoteDatasource(Ref ref) =>
    GroupsRemoteDatasource(ref.read(notionHttpServiceProvider));
