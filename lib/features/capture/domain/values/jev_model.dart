import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_model.freezed.dart';

/// Name of the Jev model that answered a request.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class JevModel with _$JevModel {
  const JevModel._();

  const factory JevModel._raw(String value) = _JevModel;

  factory JevModel(String value) => JevModel._raw(requireText(value, 'JevModel'));

  @override
  String toString() => value;
}
