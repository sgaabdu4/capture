import 'package:freezed_annotation/freezed_annotation.dart';

part 'boundary_decision.freezed.dart';

/// Split decision before one unit. [uncertain] feeds review flags;
/// provisional grouping still uses [split]. A late correction always starts
/// its own item.
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
