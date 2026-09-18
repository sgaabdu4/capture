import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_answer.freezed.dart';

/// One validated Jev answer.
@Freezed(map: .none, when: .none)
sealed class JevAnswer with _$JevAnswer {
  /// [yes] is the probability that the answer is yes. Not a boolean, not a
  /// confidence.
  const factory JevAnswer.noul(double yes) = NoulAnswer;

  /// [confidence] is a peakedness statistic of the distribution; distinct
  /// from `probabilities[choice]`. Neither is a guarantee of accuracy.
  const factory JevAnswer.choice(
    String choice,
    double confidence,
    Map<String, double> probabilities,
  ) = ChoiceAnswer;
}
