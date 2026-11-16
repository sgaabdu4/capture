import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_question.freezed.dart';

@Freezed(map: .none, when: .none)
sealed class JevQuestion with _$JevQuestion {
  /// Yes/no question; [yes] and [no] optionally describe each answer.
  const factory JevQuestion.noul(String instructions, {String? yes, String? no}) = NoulQuestion;

  @Assert('options.length >= 2 && options.length <= 255')
  factory JevQuestion.choice(String instructions, Map<String, String?> options) = ChoiceQuestion;
}
