import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:capture/features/capture/domain/dates/date_candidates.dart';
import 'package:capture/features/capture/domain/dates/resolved_date.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';

export 'package:capture/features/capture/domain/dates/capture_moment.dart';
export 'package:capture/features/capture/domain/dates/resolved_date.dart';

/// Numeric dates are read day-first (en-GB display locale) unless one part
/// is > 12. Changing locale is outside this alpha.
const dayFirstNumericDates = true;

/// A time of day on a 24-hour clock.
typedef _Clock = ({int hour, int minute});

/// A calendar month and day of month.
typedef _MonthDay = ({int month, int day});

/// A proposed date and the review flags it raises.
typedef _Dated = ({DueDate date, Set<ReviewFlag> flags});

/// Resolves relative expressions against the capture timestamp (never the
/// processing time) in the capture's time zone.
ResolvedDate resolveDate(CaptureMoment moment, {DayCandidate? day, TimeCandidate? time}) {
  if (day == null && time == null) return const .new();
  final CaptureMoment(wallClock: captured, :offsetAt, :capturedAtUtc) = moment;
  if (time case TimeCandidate(kind: .inMinutes, minutes: final int minutes)) {
    return _inMinutes(moment, minutes, hasDay: day != null);
  }
  final onDay = day == null ? const ResolvedDate() : _resolveDay(_dayOf(captured), day);
  final ResolvedDate(date: base, :flags) = onDay;
  if (day != null && base == null) {
    return .new(flags: {...flags, .chooseDate});
  }
  if (time == null) return onDay;
  final clock = _clock(time, day);
  if (clock == null) {
    return .new(date: base, flags: {...flags, .chooseAmPm}, ambiguousHour: time.hour);
  }
  final (:date, flags: dateFlags) = switch (base) {
    final DueDate date => (date: date, flags: const <ReviewFlag>{}),
    null => _nextOccurrence(captured, clock),
  };
  final withTime = date.withTime(clock.hour, clock.minute);
  return .new(
    date: withTime,
    flags: {...flags, ...dateFlags, ...checkInstant(withTime, offsetAt, capturedAtUtc)},
  );
}

ResolvedDate _inMinutes(CaptureMoment moment, int minutes, {required bool hasDay}) {
  final DateTime(:year, :month, :day, :hour, :minute) = wallClockAt(
    moment.capturedAtUtc.add(.new(minutes: minutes)),
    moment.offsetAt,
  );
  return .new(
    date: .new(year, month, day, hour: hour, minute: minute),
    flags: {if (hasDay) ReviewFlag.checkDate},
  );
}

/// Midnight UTC of [wallClock]'s calendar day; date arithmetic on it never
/// crosses a clock change.
DateTime _dayOf(DateTime wallClock) {
  final DateTime(:year, :month, :day) = wallClock;
  return .utc(year, month, day);
}

DueDate _dueDateOf(DateTime date) {
  final DateTime(:year, :month, :day) = date;
  return .new(year, month, day);
}

ResolvedDate _on(DateTime date) => .new(date: _dueDateOf(date));

/// Candidates always carry the fields of their kind; one that does not is
/// treated as an unsupported phrase.
ResolvedDate _resolveDay(DateTime today, DayCandidate day) => switch (day) {
  DayCandidate(kind: .today) => _on(today),
  DayCandidate(kind: .tomorrow) => _on(today.add(const .new(days: 1))),
  DayCandidate(kind: .dayAfter) => _on(today.add(const .new(days: 2))),
  DayCandidate(kind: .inDays, days: final int days) => _on(today.add(.new(days: days))),
  DayCandidate(kind: .weekday, weekday: final int weekday, :final nextQualifier) => _weekday(
    today,
    weekday,
    next: nextQualifier,
  ),
  DayCandidate(kind: .explicit, month: final int month, day: final int dayOfMonth, :final year) =>
    _calendar(today, year, (month: month, day: dayOfMonth)),
  DayCandidate(kind: .numeric, first: final int first, second: final int second, :final year) =>
    _numeric(today, year, first, second),
  _ => const .new(),
};

/// "Friday" said on a Friday (today or next week?) and "next Friday"
/// (ambiguous in English) propose the next occurrence and ask the user to
/// confirm.
ResolvedDate _weekday(DateTime today, int weekday, {required bool next}) {
  final delta = (weekday - today.weekday) % DateTime.daysPerWeek;
  return .new(
    date: _dueDateOf(today.add(.new(days: delta == 0 ? DateTime.daysPerWeek : delta))),
    flags: {if (delta == 0 || next) ReviewFlag.checkDate},
  );
}

/// A date without a year that has passed this year is proposed for next
/// year and flagged; an explicit past date is flagged as passed.
ResolvedDate _calendar(DateTime today, int? year, _MonthDay monthDay) {
  final candidate = _validDate(year ?? today.year, monthDay);
  if (candidate == null) return const .new();
  if (!candidate.isBefore(today)) return _on(candidate);
  if (year != null) return .new(date: _dueDateOf(candidate), flags: const {.timePassed});
  final nextYear = _validDate(today.year + 1, monthDay);
  return .new(date: nextYear == null ? null : _dueDateOf(nextYear), flags: const {.checkDate});
}

ResolvedDate _numeric(DateTime today, int? year, int first, int second) {
  const months = DateTime.monthsPerYear;
  final dayFirst = first > months || (second <= months && dayFirstNumericDates);
  final resolved = _calendar(
    today,
    year,
    dayFirst ? (month: second, day: first) : (month: first, day: second),
  );
  if (first > months || second > months) return resolved;
  return resolved.copyWith(flags: {.checkDate, ...resolved.flags});
}

DateTime? _validDate(int year, _MonthDay monthDay) {
  final (:month, :day) = monthDay;
  if (month < 1 || month > DateTime.monthsPerYear || day < 1) return null;
  final date = DateTime.utc(year, month, day);
  return date.month == month && date.day == day ? date : null;
}

/// Exact times are used as said; an ambiguous hour needs a morning/evening
/// hint from the time or its day, otherwise AM/PM must be chosen.
_Clock? _clock(TimeCandidate time, DayCandidate? day) {
  final TimeCandidate(:hour, :minute, :kind, :period) = time;
  if (hour == null) return null;
  if (kind == .exact) return (hour: hour, minute: minute);
  final hint = period != .none ? period : _dayPeriod(day);
  if (hour < 1 || hour > clockFaceHours) return null;
  return switch (hint) {
    .morning => (hour: hour % clockFaceHours, minute: minute),
    .afternoon || .evening => (hour: (hour % clockFaceHours) + clockFaceHours, minute: minute),
    .none => null,
  };
}

DayPeriod _dayPeriod(DayCandidate? day) => switch (day) {
  DayCandidate(:final period) => period,
  null => .none,
};

/// A time with no day proposes today when still ahead, else tomorrow
/// (flagged).
_Dated _nextOccurrence(DateTime captured, _Clock clock) {
  final DateTime(:hour, :minute) = captured;
  final laterToday = clock.hour > hour || (clock.hour == hour && clock.minute > minute);
  final today = _dayOf(captured);
  if (laterToday) return (date: _dueDateOf(today), flags: const {});
  return (date: _dueDateOf(today.add(const .new(days: 1))), flags: const {ReviewFlag.checkDate});
}

/// Converts a local wall time to an instant and reports clock-change gaps or
/// overlaps and times already in the past relative to [referenceUtc].
Set<ReviewFlag> checkInstant(DueDate local, UtcOffsetAt offsetAt, DateTime referenceUtc) {
  if (!local.hasTime) return const {};
  final instants = wallTimeInstants(local, offsetAt);
  return {
    if (instants.length != 1) ReviewFlag.clockChange,
    if (instants.firstOrNull case final first? when !first.isAfter(referenceUtc))
      ReviewFlag.timePassed,
  };
}

/// All UTC instants whose wall time in the zone equals [local]: one
/// normally, none inside a DST gap, two inside a DST overlap.
List<DateTime> wallTimeInstants(DueDate local, UtcOffsetAt offsetAt) {
  final naive = _naive(local);
  final offsets = <Duration>{
    for (final probe in [-1, 0, 1]) offsetAt(naive.add(.new(days: probe))),
  };
  return {
    for (final offset in offsets)
      if (_sameWallTime(wallClockAt(naive.subtract(offset), offsetAt), naive))
        naive.subtract(offset),
  }.toList()..sort();
}

/// [local]'s wall time as a UTC-flagged [DateTime]; a missing hour or minute
/// is 0.
DateTime _naive(DueDate local) => switch (local) {
  DueDate(:final year, :final month, :final day, hour: final int hour, minute: final int minute) =>
    .utc(year, month, day, hour, minute),
  DueDate(:final year, :final month, :final day, hour: final int hour) => .utc(
    year,
    month,
    day,
    hour,
  ),
  DueDate(:final year, :final month, :final day, minute: final int minute) => .utc(
    year,
    month,
    day,
    0,
    minute,
  ),
  DueDate(:final year, :final month, :final day) => .utc(year, month, day),
};

bool _sameWallTime(DateTime a, DateTime b) =>
    a.hour == b.hour && a.minute == b.minute && a.day == b.day;

/// The instant to schedule for a reminder, or null when it cannot be
/// resolved unambiguously (gap/overlap) or has no time.
DateTime? reminderInstant(DueDate local, UtcOffsetAt offsetAt) {
  if (!local.hasTime) return null;
  return switch (wallTimeInstants(local, offsetAt)) {
    [final only] => only,
    _ => null,
  };
}
