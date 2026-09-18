import 'package:capture/features/capture/domain/dates/date_kinds.dart';
import 'package:capture/features/capture/domain/dates/found_candidates.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/domain/text/titles.dart';
import 'package:capture/features/capture/domain/values/date_candidate.dart';

export 'package:capture/features/capture/domain/dates/date_kinds.dart';
export 'package:capture/features/capture/domain/dates/found_candidates.dart';
export 'package:capture/features/capture/domain/values/date_candidate.dart';

/// Supported language: English. Candidates are found by code; Jev only
/// selects which one (if any) applies. Unsupported phrases are still found
/// so the review can ask for a date instead of guessing.
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
    'january|february|march|april|may|june|july|august|september|october|november|december|jan|feb|mar|apr|jun|jul|aug|sept|sep|oct|nov|dec';
const _weekdayNames = 'monday|tuesday|wednesday|thursday|friday|saturday|sunday';
const _hourWords = 'one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve';
const _ampm = r'(a\.m\.|p\.m\.|am|pm)';
const _qty =
    r'(\d+|a|an|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|fifteen|twenty|thirty|forty|forty-five|fifty)';

/// Hours on a 12-hour clock face.
const clockFaceHours = 12;

/// Hour of "noon" / "midday".
const _noonHour = 12;

/// Minutes past the hour of "quarter past" and "half past".
const _quarterHourMinutes = 15;
const _halfHourMinutes = 30;

/// Two-digit years ("5/10/27") are read as years of this century.
const _centuryStartYear = 2000;
const _yearsPerCentury = 100;

/// A time of day on a 24-hour clock.
typedef _Clock = ({int hour, int minute});

/// The qualifier of "next Friday".
const _nextQualifier = 'next';

RegExp _re(String pattern) => .new(pattern, caseSensitive: false);

/// A candidate pattern and how one of its matches becomes a candidate.
/// [read] returns null only when a group the pattern always captures is
/// missing.
class _Pattern<C extends DateCandidate> {
  _Pattern(this.regExp, this.read);

  final RegExp regExp;
  final C? Function(RegExpMatch match, String id, SourceSpan span) read;
}

/// One accepted match of [pattern], waiting for its id in source order.
class _Hit<C extends DateCandidate> {
  const _Hit(this.pattern, this.match);

  final _Pattern<C> pattern;
  final RegExpMatch match;
}

final _dayPatterns = <_Pattern<DayCandidate>>[
  .new(_re(r'\b(the )?day after tomorrow\b'), (m, id, s) => DayCandidate(id, s, .dayAfter)),
  .new(
    _re(r'\btomorrow( morning| afternoon| evening| night)?\b'),
    (m, id, s) => DayCandidate(id, s, .tomorrow, period: _period(m[1])),
  ),
  .new(
    _re(r'\b(today|tonight|this morning|this afternoon|this evening)\b'),
    (m, id, s) => DayCandidate(id, s, .today, period: _period(m[1])),
  ),
  .new(_re('\\b(?:(this|next|on|coming) )?($_weekdayNames)\\b'), _weekday),
  .new(
    _re('\\b(\\d{1,2})(?:st|nd|rd|th)?(?: of)? ($_monthNames)\\b(?:,? (\\d{4}))?'),
    _dayThenMonth,
  ),
  .new(
    _re('\\b($_monthNames) (?:the )?(\\d{1,2})(?:st|nd|rd|th)?\\b(?:,? (\\d{4}))?'),
    _monthThenDay,
  ),
  .new(_re(r'\b(\d{1,2})/(\d{1,2})(?:/(\d{2}|\d{4}))?\b'), _numericDate),
  .new(_re('\\bin $_qty (days?|weeks?)\\b'), _inDays),
  .new(
    _re(
      r'\b(next week|this week|this weekend|next weekend|next month|next year|end of (?:the )?(?:week|month)|sometime|some time|soon|later)\b',
    ),
    (m, id, s) => DayCandidate(id, s, .unsupported),
  ),
];

final _periodAfter = _re(r'^\s*(?:in the (morning|afternoon|evening)|at night|tonight)');

final _timePatterns = <_Pattern<TimeCandidate>>[
  .new(_re('\\b(\\d{1,2})[:.](\\d{2}) ?$_ampm(?=\\W|\$)'), _digitsWithMinutes),
  .new(_re('\\b(\\d{1,2}) ?$_ampm(?=\\W|\$)'), _digitsOnTheHour),
  .new(_re('\\b($_hourWords)(?: (fifteen|thirty|forty-five))? ?$_ampm(?=\\W|\$)'), _hourWordsAmPm),
  .new(_re(r'\b([01]?\d|2[0-3]):([0-5]\d)\b'), _twentyFour),
  .new(_re(r'\b(noon|midday)\b'), (m, id, s) => TimeCandidate(id, s, .exact, hour: _noonHour)),
  .new(_re(r'\bmidnight\b'), (m, id, s) => TimeCandidate(id, s, .exact, hour: 0)),
  .new(_re('\\b(half past|quarter past|quarter to) (\\d{1,2}|$_hourWords)\\b'), _relativeHalf),
  .new(_re("\\b(\\d{1,2}|$_hourWords) o'?clock\\b"), _oClock),
  .new(
    _re('\\bat (\\d{1,2}|$_hourWords)(?: (fifteen|thirty|forty-five))?\\b(?![:./]\\d)'),
    _atHour,
  ),
  .new(_re('\\bin (half an?|$_qty) (minutes?|mins?|hours?|hrs?)\\b'), _inDuration),
  .new(
    _re(r'\bin half an hour\b'),
    (m, id, s) => TimeCandidate(id, s, .inMinutes, minutes: _halfHourMinutes),
  ),
];

/// Finds date/time phrases inside `transcript[span]`. Offsets are absolute
/// transcript offsets. IDs are `<prefix>D1…` for days and `<prefix>H1…` for
/// times, in source order.
FoundCandidates findDateCandidates(String transcript, SourceSpan span, {String? prefix}) {
  final scanner = _Scanner(transcript, span, prefix);
  final times = scanner.scan(_timePatterns, 'H');
  final days = scanner.scan(_dayPatterns, 'D');
  return .new(days, [for (final t in times) _withPeriodAfter(t, transcript)]);
}

/// Scans one passage. Matches of later patterns never overlap earlier ones,
/// times included (they are scanned first).
class _Scanner {
  _Scanner(this.transcript, this.span, this.prefix)
    : text = transcript.substring(span.start, span.end);

  final String transcript;
  final SourceSpan span;
  final String? prefix;
  final String text;
  final _taken = <ExcerptRange>[];

  List<C> scan<C extends DateCandidate>(List<_Pattern<C>> patterns, String letter) {
    final hits = <_Hit<C>>[];
    for (final pattern in patterns) {
      for (final m in pattern.regExp.allMatches(text)) {
        if (!_taken.any((t) => m.start < t.end && m.end > t.start)) {
          _taken.add((start: m.start, end: m.end));
          hits.add(.new(pattern, m));
        }
      }
    }
    hits.sort((a, b) => a.match.start.compareTo(b.match.start));
    return [
      for (int i = 0; i < hits.length; i++)
        ?hits[i].pattern.read(
          hits[i].match,
          [?prefix, '$letter${i + 1}'].join(),
          spanOf(transcript, span.start + hits[i].match.start, span.start + hits[i].match.end),
        ),
    ];
  }
}

TimeCandidate _withPeriodAfter(TimeCandidate t, String transcript) {
  if (t.kind != .ambiguous) return t;
  final m = _periodAfter.firstMatch(transcript.substring(t.span.end));
  if (m == null) return t;
  return t.copyWith(
    period: switch (m[1]) {
      final words? => _period(words),
      null => .evening,
    },
  );
}

DayPeriod _period(String? words) => switch (words?.toLowerCase()) {
  final w? when w.contains('morning') => .morning,
  final w? when w.contains('afternoon') => .afternoon,
  final w? when w.contains('evening') || w.contains('night') => .evening,
  _ => .none,
};

DayCandidate? _weekday(RegExpMatch m, String id, SourceSpan s) {
  final qualifier = m[1];
  final name = m[2];
  if (name == null) return null;
  final next = qualifier?.toLowerCase() == _nextQualifier;
  return .new(id, s, .weekday, weekday: _weekdays[name.toLowerCase()], nextQualifier: next);
}

/// "21 September", "21st of September, 2026".
DayCandidate? _dayThenMonth(RegExpMatch m, String id, SourceSpan s) {
  final dayOfMonth = m[1];
  final monthName = m[2];
  final yearText = m[3];
  if (dayOfMonth == null || monthName == null) return null;
  return .new(
    id,
    s,
    .explicit,
    day: .parse(dayOfMonth),
    month: _months[monthName.toLowerCase()],
    year: yearText == null ? null : .parse(yearText),
  );
}

/// "September 21st", "September the 21st, 2026".
DayCandidate? _monthThenDay(RegExpMatch m, String id, SourceSpan s) {
  final monthName = m[1];
  final dayOfMonth = m[2];
  final yearText = m[3];
  if (dayOfMonth == null || monthName == null) return null;
  return .new(
    id,
    s,
    .explicit,
    month: _months[monthName.toLowerCase()],
    day: .parse(dayOfMonth),
    year: yearText == null ? null : .parse(yearText),
  );
}

/// "5/10", "5/10/27".
DayCandidate? _numericDate(RegExpMatch m, String id, SourceSpan s) {
  final firstPart = m[1];
  final secondPart = m[2];
  final yearText = m[3];
  if (firstPart == null || secondPart == null) return null;
  return .new(
    id,
    s,
    .numeric,
    first: .parse(firstPart),
    second: .parse(secondPart),
    year: yearText == null ? null : _fullYear(.parse(yearText)),
  );
}

/// "in 3 days", "in two weeks".
DayCandidate? _inDays(RegExpMatch m, String id, SourceSpan s) {
  final quantity = m[1];
  final unit = m[2];
  if (quantity == null || unit == null) return null;
  final perUnit = unit.toLowerCase().startsWith('week') ? DateTime.daysPerWeek : 1;
  return .new(id, s, .inDays, days: _quantity(quantity) * perUnit);
}

/// "2:30pm", "2.30 p.m.".
TimeCandidate? _digitsWithMinutes(RegExpMatch m, String id, SourceSpan s) {
  final hourText = m[1];
  final minuteText = m[2];
  final ampm = m[3];
  if (hourText == null || minuteText == null || ampm == null) return null;
  return _exact(id, s, (hour: int.parse(hourText), minute: int.parse(minuteText)), ampm);
}

/// "2pm", "2 a.m.".
TimeCandidate? _digitsOnTheHour(RegExpMatch m, String id, SourceSpan s) {
  final hourText = m[1];
  final ampm = m[2];
  if (hourText == null || ampm == null) return null;
  return _exact(id, s, (hour: int.parse(hourText), minute: 0), ampm);
}

/// "two pm", "two thirty pm".
TimeCandidate? _hourWordsAmPm(RegExpMatch m, String id, SourceSpan s) {
  final hourWord = m[1];
  final minuteWord = m[2];
  final ampm = m[3];
  final hour = _numbers[hourWord?.toLowerCase()];
  final minute = minuteWord == null ? 0 : _numbers[minuteWord.toLowerCase()];
  if (hour == null || minute == null || ampm == null) return null;
  return _exact(id, s, (hour: hour, minute: minute), ampm);
}

/// "14:30" is exact; "2:30" needs AM/PM.
TimeCandidate? _twentyFour(RegExpMatch m, String id, SourceSpan s) {
  final hourText = m[1];
  final minuteText = m[2];
  if (hourText == null || minuteText == null) return null;
  final hour = int.parse(hourText);
  final unambiguous = hour == 0 || hour > clockFaceHours || hourText.startsWith('0');
  return .new(id, s, unambiguous ? .exact : .ambiguous, hour: hour, minute: .parse(minuteText));
}

/// "half past two", "quarter past 2", "quarter to three".
TimeCandidate? _relativeHalf(RegExpMatch m, String id, SourceSpan s) {
  final phrase = m[1];
  final hourText = m[2];
  if (phrase == null || hourText == null) return null;
  final hour = _quantity(hourText);
  return switch (phrase.toLowerCase()) {
    'half past' => .new(id, s, .ambiguous, hour: hour, minute: _halfHourMinutes),
    'quarter past' => .new(id, s, .ambiguous, hour: hour, minute: _quarterHourMinutes),
    _ => .new(
      id,
      s,
      .ambiguous,
      hour: hour == 1 ? clockFaceHours : hour - 1,
      minute: Duration.minutesPerHour - _quarterHourMinutes,
    ),
  };
}

/// "3 o'clock", "three oclock".
TimeCandidate? _oClock(RegExpMatch m, String id, SourceSpan s) {
  final hourText = m[1];
  if (hourText == null) return null;
  return .new(id, s, .ambiguous, hour: _quantity(hourText));
}

/// "at 3", "at three thirty".
TimeCandidate? _atHour(RegExpMatch m, String id, SourceSpan s) {
  final hourText = m[1];
  final minuteWord = m[2];
  final minute = minuteWord == null ? 0 : _numbers[minuteWord.toLowerCase()];
  if (hourText == null || minute == null) return null;
  return .new(id, s, .ambiguous, hour: _quantity(hourText), minute: minute);
}

/// "in 20 minutes", "in half an hour", "in 2 hrs".
TimeCandidate? _inDuration(RegExpMatch m, String id, SourceSpan s) {
  final quantity = m[1];
  final unit = m[3];
  if (quantity == null || unit == null) return null;
  return .new(id, s, .inMinutes, minutes: _durationMinutes(quantity, unit));
}

TimeCandidate _exact(String id, SourceSpan s, _Clock clock, String ampm) {
  final (:hour, :minute) = clock;
  final pm = ampm.toLowerCase().startsWith('p');
  final valid = hour >= 1 && hour <= clockFaceHours && minute < Duration.minutesPerHour;
  if (!valid) return .new(id, s, .ambiguous, hour: hour, minute: minute);
  final h24 = (hour % clockFaceHours) + (pm ? clockFaceHours : 0);
  return .new(id, s, .exact, hour: h24, minute: minute);
}

/// Digits or a number word; every captured quantity is one of these.
int _quantity(String text) {
  if (int.tryParse(text) case final number?) return number;
  if (_numbers[text.toLowerCase()] case final number?) return number;
  return 1;
}

int _durationMinutes(String qty, String unit) {
  final lower = qty.toLowerCase();
  final hours = unit.toLowerCase().startsWith('h');
  if (lower.startsWith('half')) return hours ? _halfHourMinutes : 1;
  final n = _quantity(lower);
  return hours ? n * Duration.minutesPerHour : n;
}

int _fullYear(int year) => year < _yearsPerCentury ? _centuryStartYear + year : year;
