import 'package:capture/features/capture/domain/dates/date_kinds.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_candidate.freezed.dart';

/// A date or time phrase found by code in the transcript. Jev only selects
/// which one (if any) applies.
@Freezed(map: .none, when: .none)
sealed class DateCandidate with _$DateCandidate {
  /// A day expression. [weekday] is 1 = Monday … 7 = Sunday; [first] and
  /// [second] are numeric date parts in spoken order (locale-dependent);
  /// [days] is the offset of "in 3 days" / "in 2 weeks".
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

  /// A time expression. [hour] is 0–23 for exact times and 1–12 for
  /// ambiguous ones; [minutes] is the offset of "in 20 minutes" /
  /// "in 2 hours"; [period] comes from "at 2 in the afternoon".
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
