import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_id.freezed.dart';

/// Id of one proposed note or task, made by code; saved to Notion as the
/// Library page's Item ID.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class ItemId with _$ItemId {
  const ItemId._();

  const factory ItemId._raw(String value) = _ItemId;

  factory ItemId(String value) => ItemId._raw(requireText(value, 'ItemId'));

  @override
  String toString() => value;
}
