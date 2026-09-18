import 'package:capture/features/capture/domain/entities/source_span.dart';

/// Supported language: English. Candidates are found by code; Jev only
/// selects which one (if any) applies. Unsupported phrases are still found
/// so the review can ask for a date instead of guessing.
enum DayKind { today, tomorrow, dayAfter, weekday, explicit, numeric, inDays, unsupported }

enum TimeKind { exact, ambiguous, inMinutes }

enum DayPeriod { none, morning, afternoon, evening }

sealed class DateCandidate {
  const DateCandidate(this.id, this.span);
  final String id;
  final SourceSpan span;
}

class DayCandidate extends DateCandidate {
  const DayCandidate(
    super.id,
    super.span,
    this.kind, {
    this.weekday,
    this.nextQualifier = false,
    this.month,
    this.day,
    this.year,
    this.first,
    this.second,
    this.days,
    this.period = DayPeriod.none,
  });

  final DayKind kind;

  /// 1 = Monday … 7 = Sunday.
  final int? weekday;
  final bool nextQualifier;
  final int? month;
  final int? day;
  final int? year;

  /// Numeric date parts in spoken order (locale-dependent).
  final int? first;
  final int? second;
  final int? days;
  final DayPeriod period;
}

class TimeCandidate extends DateCandidate {
  const TimeCandidate(
    super.id,
    super.span,
    this.kind, {
    this.hour,
    this.minute = 0,
    this.minutes,
    this.period = DayPeriod.none,
  });

  final TimeKind kind;

  /// 0–23 for exact; 1–12 for ambiguous.
  final int? hour;
  final int minute;

  /// Offset for "in 20 minutes" / "in 2 hours".
  final int? minutes;

  /// "at 2 in the afternoon" → afternoon.
  final DayPeriod period;
}

const _months = {
  'january': 1, 'jan': 1, 'february': 2, 'feb': 2, 'march': 3, 'mar': 3, //
  'april': 4, 'apr': 4, 'may': 5, 'june': 6, 'jun': 6, 'july': 7, 'jul': 7,
  'august': 8, 'aug': 8, 'september': 9, 'sept': 9, 'sep': 9, 'october': 10,
  'oct': 10, 'november': 11, 'nov': 11, 'december': 12, 'dec': 12,
};

const _weekdays = {
  'monday': 1, 'tuesday': 2, 'wednesday': 3, 'thursday': 4, 'friday': 5, //
  'saturday': 6, 'sunday': 7,
};

const _numbers = {
  'a': 1, 'an': 1, 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, //
  'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10, 'eleven': 11,
  'twelve': 12, 'fifteen': 15, 'twenty': 20, 'thirty': 30, 'forty': 40,
  'forty-five': 45, 'fifty': 50,
};

const _monthNames =
    'january|february|march|april|may|june|july|august|september|october|'
    'november|december|jan|feb|mar|apr|jun|jul|aug|sept|sep|oct|nov|dec';
const _weekdayNames = 'monday|tuesday|wednesday|thursday|friday|saturday|sunday';
const _hourWords = 'one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve';
const _ampm = r'(a\.m\.|p\.m\.|am|pm)';
const _qty =
    r'(\d+|a|an|one|two|three|four|five|six|seven|eight|nine|ten|'
    r'eleven|twelve|fifteen|twenty|thirty|forty|forty-five|fifty)';

RegExp _re(String pattern) => RegExp(pattern, caseSensitive: false);

final _dayPatterns = <(RegExp, DayCandidate Function(RegExpMatch, String, SourceSpan))>[
  (_re(r'\b(the )?day after tomorrow\b'), (m, id, s) => DayCandidate(id, s, DayKind.dayAfter)),
  (
    _re(r'\btomorrow( morning| afternoon| evening| night)?\b'),
    (m, id, s) => DayCandidate(id, s, DayKind.tomorrow, period: _period(m[1])),
  ),
  (
    _re(r'\b(today|tonight|this morning|this afternoon|this evening)\b'),
    (m, id, s) => DayCandidate(id, s, DayKind.today, period: _period(m[1])),
  ),
  (
    _re('\\b(?:(this|next|on|coming) )?($_weekdayNames)\\b'),
    (m, id, s) => DayCandidate(
      id,
      s,
      DayKind.weekday,
      weekday: _weekdays[m[2]!.toLowerCase()],
      nextQualifier: m[1]?.toLowerCase() == 'next',
    ),
  ),
  (
    _re('\\b(\\d{1,2})(?:st|nd|rd|th)?(?: of)? ($_monthNames)\\b(?:,? (\\d{4}))?'),
    (m, id, s) => DayCandidate(
      id,
      s,
      DayKind.explicit,
      day: int.parse(m[1]!),
      month: _months[m[2]!.toLowerCase()],
      year: m[3] == null ? null : int.parse(m[3]!),
    ),
  ),
  (
    _re('\\b($_monthNames) (?:the )?(\\d{1,2})(?:st|nd|rd|th)?\\b(?:,? (\\d{4}))?'),
    (m, id, s) => DayCandidate(
      id,
      s,
      DayKind.explicit,
      month: _months[m[1]!.toLowerCase()],
      day: int.parse(m[2]!),
      year: m[3] == null ? null : int.parse(m[3]!),
    ),
  ),
  (
    _re(r'\b(\d{1,2})/(\d{1,2})(?:/(\d{2}|\d{4}))?\b'),
    (m, id, s) => DayCandidate(
      id,
      s,
      DayKind.numeric,
      first: int.parse(m[1]!),
      second: int.parse(m[2]!),
      year: m[3] == null ? null : _fullYear(int.parse(m[3]!)),
    ),
  ),
  (
    _re('\\bin $_qty (days?|weeks?)\\b'),
    (m, id, s) => DayCandidate(
      id,
      s,
      DayKind.inDays,
      days: _quantity(m[1]!) * (m[2]!.toLowerCase().startsWith('week') ? 7 : 1),
    ),
  ),
  (
    _re(
      r'\b(next week|this week|this weekend|next weekend|next month|next year|'
      r'end of (?:the )?(?:week|month)|sometime|some time|soon|later)\b',
    ),
    (m, id, s) => DayCandidate(id, s, DayKind.unsupported),
  ),
];

final _periodAfter = _re(r'^\s*(?:in the (morning|afternoon|evening)|at night|tonight)');

final _timePatterns = <(RegExp, TimeCandidate Function(RegExpMatch, String, SourceSpan))>[
  (
    _re('\\b(\\d{1,2})[:.](\\d{2}) ?$_ampm(?=\\W|\$)'),
    (m, id, s) => _exact(id, s, int.parse(m[1]!), int.parse(m[2]!), m[3]!),
  ),
  (_re('\\b(\\d{1,2}) ?$_ampm(?=\\W|\$)'), (m, id, s) => _exact(id, s, int.parse(m[1]!), 0, m[2]!)),
  (
    _re('\\b($_hourWords)(?: (fifteen|thirty|forty-five))? ?$_ampm(?=\\W|\$)'),
    (m, id, s) => _exact(
      id,
      s,
      _numbers[m[1]!.toLowerCase()]!,
      m[2] == null ? 0 : _numbers[m[2]!.toLowerCase()]!,
      m[3]!,
    ),
  ),
  (
    _re(r'\b([01]?\d|2[0-3]):([0-5]\d)\b'),
    (m, id, s) => _twentyFour(id, s, m[1]!, int.parse(m[2]!)),
  ),
  (_re(r'\b(noon|midday)\b'), (m, id, s) => TimeCandidate(id, s, TimeKind.exact, hour: 12)),
  (_re(r'\bmidnight\b'), (m, id, s) => TimeCandidate(id, s, TimeKind.exact, hour: 0)),
  (
    _re('\\b(half past|quarter past|quarter to) (\\d{1,2}|$_hourWords)\\b'),
    (m, id, s) => _relativeHalf(id, s, m[1]!.toLowerCase(), m[2]!),
  ),
  (
    _re("\\b(\\d{1,2}|$_hourWords) o'?clock\\b"),
    (m, id, s) => TimeCandidate(id, s, TimeKind.ambiguous, hour: _quantity(m[1]!)),
  ),
  (
    _re('\\bat (\\d{1,2}|$_hourWords)(?: (fifteen|thirty|forty-five))?\\b(?![:./]\\d)'),
    (m, id, s) => TimeCandidate(
      id,
      s,
      TimeKind.ambiguous,
      hour: _quantity(m[1]!),
      minute: m[2] == null ? 0 : _numbers[m[2]!.toLowerCase()]!,
    ),
  ),
  (
    _re('\\bin (half an?|$_qty) (minutes?|mins?|hours?|hrs?)\\b'),
    (m, id, s) => TimeCandidate(id, s, TimeKind.inMinutes, minutes: _durationMinutes(m[1]!, m[3]!)),
  ),
  (
    _re(r'\bin half an hour\b'),
    (m, id, s) => TimeCandidate(id, s, TimeKind.inMinutes, minutes: 30),
  ),
];

class FoundCandidates {
  const FoundCandidates(this.days, this.times);
  final List<DayCandidate> days;
  final List<TimeCandidate> times;
  bool get isEmpty => days.isEmpty && times.isEmpty;
}

/// Finds date/time phrases inside `transcript[span]`. Offsets are absolute
/// transcript offsets. IDs are `<prefix>D1…` for days and `<prefix>H1…` for
/// times, in source order.
FoundCandidates findDateCandidates(String transcript, SourceSpan span, {String prefix = ''}) {
  final text = transcript.substring(span.start, span.end);
  final taken = <(int, int)>[];
  List<C> scan<C extends DateCandidate>(
    List<(RegExp, C Function(RegExpMatch, String, SourceSpan))> patterns,
    String letter,
  ) {
    final found = <(int, C Function(String, SourceSpan), int)>[];
    for (final (pattern, build) in patterns) {
      for (final m in pattern.allMatches(text)) {
        if (taken.any((t) => m.start < t.$2 && m.end > t.$1)) continue;
        taken.add((m.start, m.end));
        found.add((m.start, (id, s) => build(m, id, s), m.end));
      }
    }
    found.sort((a, b) => a.$1.compareTo(b.$1));
    return [
      for (var i = 0; i < found.length; i++)
        found[i].$2(
          '$prefix$letter${i + 1}',
          SourceSpan.of(transcript, span.start + found[i].$1, span.start + found[i].$3),
        ),
    ];
  }

  final times = scan(_timePatterns, 'H');
  final days = scan(_dayPatterns, 'D');
  return FoundCandidates(days, [for (final t in times) _withPeriodAfter(t, transcript)]);
}

TimeCandidate _withPeriodAfter(TimeCandidate t, String transcript) {
  if (t.kind != TimeKind.ambiguous) return t;
  final m = _periodAfter.firstMatch(transcript.substring(t.span.end));
  if (m == null) return t;
  final period = m[1] == null ? DayPeriod.evening : _period(m[1]);
  return TimeCandidate(t.id, t.span, t.kind, hour: t.hour, minute: t.minute, period: period);
}

DayPeriod _period(String? words) {
  final w = (words ?? '').toLowerCase();
  if (w.contains('morning')) return DayPeriod.morning;
  if (w.contains('afternoon')) return DayPeriod.afternoon;
  if (w.contains('evening') || w.contains('night')) return DayPeriod.evening;
  return DayPeriod.none;
}

TimeCandidate _exact(String id, SourceSpan s, int hour, int minute, String ampm) {
  final pm = ampm.toLowerCase().startsWith('p');
  final valid = hour >= 1 && hour <= 12 && minute < 60;
  if (!valid) {
    return TimeCandidate(id, s, TimeKind.ambiguous, hour: hour, minute: minute);
  }
  final h24 = (hour % 12) + (pm ? 12 : 0);
  return TimeCandidate(id, s, TimeKind.exact, hour: h24, minute: minute);
}

TimeCandidate _twentyFour(String id, SourceSpan s, String hourText, int minute) {
  final hour = int.parse(hourText);
  final unambiguous = hour == 0 || hour > 12 || hourText.startsWith('0');
  return TimeCandidate(
    id,
    s,
    unambiguous ? TimeKind.exact : TimeKind.ambiguous,
    hour: hour,
    minute: minute,
  );
}

TimeCandidate _relativeHalf(String id, SourceSpan s, String phrase, String hourText) {
  final hour = _quantity(hourText);
  return switch (phrase) {
    'half past' => TimeCandidate(id, s, TimeKind.ambiguous, hour: hour, minute: 30),
    'quarter past' => TimeCandidate(id, s, TimeKind.ambiguous, hour: hour, minute: 15),
    _ => TimeCandidate(id, s, TimeKind.ambiguous, hour: hour == 1 ? 12 : hour - 1, minute: 45),
  };
}

int _quantity(String text) => int.tryParse(text) ?? _numbers[text.toLowerCase()] ?? 1;

int _durationMinutes(String qty, String unit) {
  final lower = qty.toLowerCase();
  final hours = unit.toLowerCase().startsWith('h');
  if (lower.startsWith('half')) return hours ? 30 : 1;
  final n = _quantity(lower);
  return hours ? n * 60 : n;
}

int _fullYear(int year) => year < 100 ? 2000 + year : year;
