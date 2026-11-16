import 'package:freezed_annotation/freezed_annotation.dart';

part 'boundary_decision.freezed.dart';

@freezed
sealed class BoundaryDecision with _$BoundaryDecision {
  const factory BoundaryDecision({
    required bool split,
    required bool uncertain,

    /// Jev's P(yes) for "a new thought starts here".
    required double yes,
    @Default(false) bool lateCorrection,
  }) = _BoundaryDecision;
}
