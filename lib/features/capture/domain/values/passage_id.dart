import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passage_id.freezed.dart';

/// Label of a transcript unit or thought (`U001`, `T1`), as named to Jev.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class PassageId with _$PassageId {
  const PassageId._();

  const factory PassageId._raw(String value) = _PassageId;

  factory PassageId(String value) => PassageId._raw(requireText(value, 'PassageId'));

  @override
  String toString() => value;
}
