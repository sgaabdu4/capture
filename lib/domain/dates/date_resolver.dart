import 'package:timezone/timezone.dart' as tz;

import '../models.dart';
import 'date_candidates.dart';

/// Result of resolving the selected day/time candidates for one item.
class ResolvedDate {
  const ResolvedDate({this.date, this.flags = const {}, this.ambiguousHour});

  /// Local wall-clock date (and time when known) in the capture time zone.
  final DueDate? date;
  final Set<ReviewFlag> flags;

  /// 1–12 when AM/PM must be chosen by the user.
  final int? ambiguousHour;
}

/// Numeric dates are read day-first (en-GB display locale) unless one part
/// is > 12. Changing locale is outside this alpha.
const dayFirstNumericDates = true;

/// Resolves relative expressions against the capture timestamp (never the
/// processing time) in the capture's IANA time zone.
ResolvedDate resolveDate({
  required DateTime capturedAtUtc,
  required tz.Location location,
  DayCandidate? day,
  TimeCandidate? time,
}) {
  if (day == null && time == null) return const ResolvedDate();
  final captured = tz.TZDateTime.from(capturedAtUtc, location);
  if (time?.kind == TimeKind.inMinutes) {
    return _inMinutes(captured, time!, hasDay: day != null);
  }
  final flags = <ReviewFlag>{};
  final base = day == null ? null : _resolveDay(captured, day, flags);
  if (day != null && base == null) {
    return ResolvedDate(flags: {...flags, ReviewFlag.chooseDate});
  }
  if (time == null) return ResolvedDate(date: base, flags: flags);
  final period = day?.period ?? DayPeriod.none;
  final clock = _clock(time, period);
  if (clock == null) {
    return ResolvedDate(
      date: base,
      flags: {...flags, ReviewFlag.chooseAmPm},
      ambiguousHour: time.hour,
    );
  }
  final date = base ?? _nextOccurrence(captured, clock.$1, clock.$2, flags);
  final withTime = date.withTime(clock.$1, clock.$2);
  flags.addAll(checkInstant(withTime, location, capturedAtUtc));
  return ResolvedDate(date: withTime, flags: flags);
}

ResolvedDate _inMinutes(
  tz.TZDateTime captured,
  TimeCandidate time, {
  required bool hasDay,
}) {
  final at = captured.add(Duration(minutes: time.minutes ?? 0));
  return ResolvedDate(
    date: DueDate(at.year, at.month, at.day, hour: at.hour, minute: at.minute),
    flags: {if (hasDay) ReviewFlag.checkDate},
  );
}

DueDate? _resolveDay(
  tz.TZDateTime captured,
  DayCandidate day,
  Set<ReviewFlag> flags,
) {
  final today = DateTime.utc(captured.year, captured.month, captured.day);
  DueDate from(DateTime d) => DueDate(d.year, d.month, d.day);
  switch (day.kind) {
    case DayKind.today:
      return from(today);
    case DayKind.tomorrow:
      return from(today.add(const Duration(days: 1)));
    case DayKind.dayAfter:
      return from(today.add(const Duration(days: 2)));
    case DayKind.inDays:
      return from(today.add(Duration(days: day.days ?? 0)));
    case DayKind.weekday:
      return from(_weekday(today, day, flags));
    case DayKind.explicit:
      return _calendar(today, day.year, day.month!, day.day!, flags);
    case DayKind.numeric:
      return _numeric(today, day, flags);
    case DayKind.unsupported:
      return null;
  }
}

DateTime _weekday(DateTime today, DayCandidate day, Set<ReviewFlag> flags) {
  var delta = (day.weekday! - today.weekday) % 7;
  if (delta == 0) {
    // "Friday" said on a Friday: today or next week? Ask.
    flags.add(ReviewFlag.checkDate);
    delta = 7;
  }
  // "next Friday" is ambiguous in English; propose the next occurrence and
  // ask the user to confirm.
  if (day.nextQualifier) flags.add(ReviewFlag.checkDate);
  return today.add(Duration(days: delta));
}

DueDate? _calendar(
  DateTime today,
  int? year,
  int month,
  int dayOfMonth,
  Set<ReviewFlag> flags,
) {
  var y = year ?? today.year;
  var candidate = _validDate(y, month, dayOfMonth);
  if (candidate == null) return null;
  if (year == null && candidate.isBefore(today)) {
    y += 1;
    candidate = _validDate(y, month, dayOfMonth);
    flags.add(ReviewFlag.checkDate);
  } else if (candidate.isBefore(today)) {
    flags.add(ReviewFlag.timePassed);
  }
  return candidate == null
      ? null
      : DueDate(candidate.year, candidate.month, candidate.day);
}

DueDate? _numeric(DateTime today, DayCandidate day, Set<ReviewFlag> flags) {
  final a = day.first!;
  final b = day.second!;
  final dayFirst = a > 12 || (b <= 12 && dayFirstNumericDates);
  if (a <= 12 && b <= 12) flags.add(ReviewFlag.checkDate);
  return dayFirst
      ? _calendar(today, day.year, b, a, flags)
      : _calendar(today, day.year, a, b, flags);
}

DateTime? _validDate(int year, int month, int day) {
  if (month < 1 || month > 12 || day < 1) return null;
  final d = DateTime.utc(year, month, day);
  return d.month == month && d.day == day ? d : null;
}

(int, int)? _clock(TimeCandidate time, DayPeriod period) {
  final hour = time.hour!;
  if (time.kind == TimeKind.exact) return (hour, time.minute);
  final hint = time.period != DayPeriod.none ? time.period : period;
  if (hour < 1 || hour > 12) return null;
  return switch (hint) {
    DayPeriod.morning => (hour % 12, time.minute),
    DayPeriod.afternoon || DayPeriod.evening => ((hour % 12) + 12, time.minute),
    DayPeriod.none => null,
  };
}

DueDate _nextOccurrence(
  tz.TZDateTime captured,
  int hour,
  int minute,
  Set<ReviewFlag> flags,
) {
  final laterToday =
      hour > captured.hour ||
      (hour == captured.hour && minute > captured.minute);
  if (laterToday) return DueDate(captured.year, captured.month, captured.day);
  // A time with no day that has already passed today: propose tomorrow.
  flags.add(ReviewFlag.checkDate);
  final t = DateTime.utc(
    captured.year,
    captured.month,
    captured.day,
  ).add(const Duration(days: 1));
  return DueDate(t.year, t.month, t.day);
}

/// Converts a local wall time to an instant and reports clock-change gaps or
/// overlaps and times already in the past relative to [referenceUtc].
Set<ReviewFlag> checkInstant(
  DueDate local,
  tz.Location location,
  DateTime referenceUtc,
) {
  if (!local.hasTime) return const {};
  final instants = wallTimeInstants(local, location);
  return {
    if (instants.length != 1) ReviewFlag.clockChange,
    if (instants.isNotEmpty && !instants.first.isAfter(referenceUtc))
      ReviewFlag.timePassed,
  };
}

/// All UTC instants whose wall time in [location] equals [local]: one
/// normally, none inside a DST gap, two inside a DST overlap.
List<DateTime> wallTimeInstants(DueDate local, tz.Location location) {
  final naive = DateTime.utc(
    local.year,
    local.month,
    local.day,
    local.hour ?? 0,
    local.minute ?? 0,
  );
  final offsets = <Duration>{
    for (final probe in [-1, 0, 1])
      location
          .timeZone(naive.add(Duration(days: probe)).millisecondsSinceEpoch)
          .offset,
  };
  final instants = <DateTime>{};
  for (final offset in offsets) {
    final instant = naive.subtract(offset);
    final back = tz.TZDateTime.from(instant, location);
    if (back.hour == naive.hour &&
        back.minute == naive.minute &&
        back.day == naive.day) {
      instants.add(instant);
    }
  }
  return instants.toList()..sort();
}

/// The instant to schedule for a reminder, or null when it cannot be
/// resolved unambiguously (gap/overlap) or has no time.
DateTime? reminderInstant(DueDate local, tz.Location location) {
  if (!local.hasTime) return null;
  final instants = wallTimeInstants(local, location);
  return instants.length == 1 ? instants.first : null;
}
