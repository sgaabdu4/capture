import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_state.freezed.dart';

/// The context text sent to Jev with every question of one pass.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class JevState with _$JevState {
  const JevState._();

  const factory JevState._raw(String value) = _JevState;

  factory JevState(String value) => JevState._raw(requireText(value, 'JevState'));

  @override
  String toString() => value;
}
