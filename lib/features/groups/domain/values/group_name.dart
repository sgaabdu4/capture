import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_name.freezed.dart';

/// A group's name, also the option Jev chooses between.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class GroupName with _$GroupName {
  const GroupName._();

  const factory GroupName._raw(String value) = _GroupName;

  factory GroupName(String value) => GroupName._raw(requireText(value, 'GroupName'));

  @override
  String toString() => value;
}
