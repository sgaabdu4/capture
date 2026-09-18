import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resolved_date.freezed.dart';

/// Result of resolving the selected day/time candidates for one item.
@freezed
sealed class ResolvedDate with _$ResolvedDate {
  const factory ResolvedDate({
    /// Local wall-clock date (and time when known) in the capture time zone.
    DueDate? date,
    @Default({}) Set<ReviewFlag> flags,

    /// 1–12 when AM/PM must be chosen by the user.
    int? ambiguousHour,
  }) = _ResolvedDate;
}
