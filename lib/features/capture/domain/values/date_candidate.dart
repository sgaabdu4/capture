import 'package:capture/features/capture/domain/dates/date_kinds.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_candidate.freezed.dart';

@Freezed(map: .none, when: .none)
sealed class DateCandidate with _$DateCandidate {
  const factory DateCandidate.day(
    String id,
    SourceSpan span,
    DayKind kind, {
    int? weekday,
    @Default(false) bool nextQualifier,
    int? month,
    int? day,
    int? year,
    int? first,
    int? second,
    int? days,
    @Default(DayPeriod.none) DayPeriod period,
  }) = DayCandidate;

  const factory DateCandidate.time(
    String id,
    SourceSpan span,
    TimeKind kind, {
    int? hour,
    @Default(0) int minute,
    int? minutes,
    @Default(DayPeriod.none) DayPeriod period,
  }) = TimeCandidate;
}
