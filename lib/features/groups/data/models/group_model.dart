import 'package:capture/core/domain/values/required_text.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
sealed class GroupModel with _$GroupModel {
  const GroupModel._();

  const factory GroupModel({
    required String id,
    required String name,
    required String description,
    @Default(false) bool archived,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);

  factory GroupModel.fromEntity(Group g) => GroupModel(
    id: g.id.value,
    name: g.name.value,
    description: g.description ?? '',
    archived: g.archived,
  );

  Group toEntity() => .new(
    id: .new(id),
    name: .new(name),
    description: optionalText(description),
    archived: archived,
  );
}
