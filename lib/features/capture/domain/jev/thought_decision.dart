import 'package:capture/features/capture/domain/text/thought.dart';
import 'package:capture/features/capture/domain/values/date_candidate.dart';
import 'package:capture/features/groups/domain/values/group_name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'thought_decision.freezed.dart';

/// Decoded decisions for one thought. Code combines them; no answer assumes
/// another's result.
@freezed
sealed class ThoughtDecision with _$ThoughtDecision {
  const factory ThoughtDecision({
    required Thought thought,
    required GroupName groupOption,
    required double groupConfidence,

    /// P(yes) that the thought is a to-do.
    required double task,

    /// P(yes) that the thought asks for a reminder.
    required double alert,

    /// P(yes) that the thought asks the app to recall something.
    required double recall,
    DayCandidate? day,
    @Default(1) double dayConfidence,
    TimeCandidate? time,
    @Default(1) double timeConfidence,
  }) = _ThoughtDecision;
}
