import 'dart:convert';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/features/groups/data/models/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_local_datasource.g.dart';

/// Last groups fetched from Notion, so capture works offline.
abstract interface class IGroupsLocalDatasource {
  List<GroupModel> read();
  void write(List<GroupModel> groups);
}

@Riverpod(keepAlive: true)
IGroupsLocalDatasource groupsLocalDatasource(Ref ref) =>
    GroupsLocalDatasource(ref.read(keyValueLocalDatasourceProvider));

class GroupsLocalDatasource implements IGroupsLocalDatasource {
  GroupsLocalDatasource(this._kv);
  final IKeyValueLocalDatasource _kv;

  static const _key = 'groups';

  @override
  List<GroupModel> read() => switch (_kv.read(_key)) {
    final String raw => [
      if ((jsonDecode(raw) as Object?) case final List<Object?> list)
        for (final item in list)
          if (item case final Map<String, dynamic> json) GroupModel.fromJson(json),
    ],
    null => const [],
  };

  @override
  void write(List<GroupModel> groups) =>
      _kv.write(_key, jsonEncode([for (final g in groups) g.toJson()]));
}
