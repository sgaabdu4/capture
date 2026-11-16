import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_answer.freezed.dart';

/// One validated Jev answer.
@Freezed(map: .none, when: .none)
sealed class JevAnswer with _$JevAnswer {
  const factory JevAnswer.noul(double yes) = NoulAnswer;

  const factory JevAnswer.choice(
    String choice,
    double confidence,
    Map<String, double> probabilities,
  ) = ChoiceAnswer;
}
