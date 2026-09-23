import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notion_id.freezed.dart';

/// Id of a Notion page or data source.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class NotionId with _$NotionId {
  const NotionId._();

  const factory NotionId._raw(String value) = _NotionId;

  factory NotionId(String value) => NotionId._raw(requireText(value, 'NotionId'));

  @override
  String toString() => value;
}
