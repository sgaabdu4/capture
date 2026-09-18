import 'package:capture/features/capture/domain/values/date_candidate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'found_candidates.freezed.dart';

/// Day and time candidates found in one passage, each in source order.
@freezed
sealed class FoundCandidates with _$FoundCandidates {
  const FoundCandidates._();

  const factory FoundCandidates(List<DayCandidate> days, List<TimeCandidate> times) =
      _FoundCandidates;

  bool get isEmpty => days.isEmpty && times.isEmpty;
}
