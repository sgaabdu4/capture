import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_question.freezed.dart';

/// One question sent to Jev. Keys are not seen by the model, so every
/// instruction names its target unit/thought.
@Freezed(map: .none, when: .none)
sealed class JevQuestion with _$JevQuestion {
  /// Yes/no question; [yes] and [no] optionally describe each answer.
  const factory JevQuestion.noul(String instructions, {String? yes, String? no}) = NoulQuestion;

  /// Choice among [options]: option name → meaningful description (both are
  /// seen by the model).
  @Assert('options.length >= 2 && options.length <= 255')
  factory JevQuestion.choice(String instructions, Map<String, String?> options) = ChoiceQuestion;
}
