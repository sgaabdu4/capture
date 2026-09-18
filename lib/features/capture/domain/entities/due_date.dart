import 'package:freezed_annotation/freezed_annotation.dart';

part 'due_date.freezed.dart';

/// A calendar date with optional time-of-day, in the capture's time zone.
/// Precision is explicit: [hour] and [minute] are null for date-only
/// deadlines.
@freezed
sealed class DueDate with _$DueDate {
  const DueDate._();

  const factory DueDate(int year, int month, int day, {int? hour, int? minute}) = _DueDate;

  static const _yearDigits = 4;
  static const _fieldDigits = 2;

  bool get hasTime => hour != null;

  DueDate withTime(int hour, int minute) => .new(year, month, day, hour: hour, minute: minute);

  DueDate get dateOnly => .new(year, month, day);

  /// ISO date or local date-time without offset, e.g. `2026-09-19` or
  /// `2026-09-19T14:00:00`.
  String get iso {
    final date = '${year.toString().padLeft(_yearDigits, '0')}-${_two(month)}-${_two(day)}';
    return switch (hour) {
      final int h => '${date}T${_two(h)}:${_two(minute ?? 0)}:00',
      null => date,
    };
  }

  static String _two(int value) => value.toString().padLeft(_fieldDigits, '0');
}
