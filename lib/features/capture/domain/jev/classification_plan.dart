import 'package:capture/features/capture/domain/dates/found_candidates.dart';
import 'package:capture/features/capture/domain/values/jev_question.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'classification_plan.freezed.dart';

/// Everything needed to ask and later decode the classification pass. The
/// option → group-id mapping is local; Jev never sees ids and cannot invent
/// groups.
@freezed
sealed class ClassificationPlan with _$ClassificationPlan {
  const factory ClassificationPlan({
    required String state,
    required Map<String, JevQuestion> questions,

    /// Option name → group id (null for the implicit Unsorted fallback).
    required Map<String, String?> groupOptions,

    /// The user's active Unsorted group, filed to when an option has no id.
    required String? unsortedGroupId,

    /// Date/time candidates per thought id.
    required Map<String, FoundCandidates> candidates,
  }) = _ClassificationPlan;
}
