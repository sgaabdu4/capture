import 'package:capture/features/capture/domain/dates/date_candidates.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Thu 17 Sep 2026 20:09 in London (BST, UTC+1).
final _captured = DateTime.utc(2026, 9, 17, 19, 9);

Duration _londonOffset(DateTime instantUtc) =>
    tz.getLocation('Europe/London').timeZone(instantUtc.millisecondsSinceEpoch).offset;

FoundCandidates _find(String text) => findDateCandidates(text, spanOf(text, 0, text.length));

/// Resolves the [day]th day and [time]th time candidate of [text]; a
/// negative index leaves that candidate out.
ResolvedDate _resolve(String text, {int day = 0, int time = 0}) {
  final FoundCandidates(:days, :times) = _find(text);
  return resolveDate(
    .new(capturedAtUtc: _captured, offsetAt: _londonOffset),
    day: day < 0 ? null : days.elementAtOrNull(day),
    time: time < 0 ? null : times.elementAtOrNull(time),
  );
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('tomorrow at 2pm resolves against the capture time', () {
    final r = _resolve('Remind me tomorrow at 2pm');
    expect(r.date, equals(const DueDate(2026, 9, 18, hour: 14, minute: 0)));
    expect(r.flags, isEmpty);
  });

  test('a correction yields two time candidates; the chosen one is used', () {
    const text = 'Buy groceries tomorrow at 2pm. Actually, make that 3pm.';
    final found = _find(text);
    expect(found.times.map((t) => t.span.excerpt.value), equals(['2pm', '3pm']));
    expect(found.times.map((t) => t.id), equals(['H1', 'H2']));
    final r = _resolve(text, time: 1);
    expect(r.date, equals(const DueDate(2026, 9, 18, hour: 15, minute: 0)));
  });

  test('tomorrow at two asks for AM/PM', () {
    final r = _resolve('Call mum tomorrow at two');
    expect(r.flags, contains(ReviewFlag.chooseAmPm));
    expect(r.ambiguousHour, equals(2));
    expect(r.date, equals(const DueDate(2026, 9, 18)));
  });

  test('a period word resolves AM/PM', () {
    expect(
      _resolve('Dinner tonight at 8').date,
      equals(const DueDate(2026, 9, 17, hour: 20, minute: 0)),
    );
    expect(
      _resolve('Call at 2 in the afternoon tomorrow').date,
      equals(const DueDate(2026, 9, 18, hour: 14, minute: 0)),
    );
  });

  test('finish by Friday is a date-only deadline', () {
    final r = _resolve('Finish this by Friday', time: -1);
    expect(r.date, equals(const DueDate(2026, 9, 18)));
    expect(r.date?.hasTime, isFalse);
  });

  test('sometime next week keeps the wording and asks for a date', () {
    final found = _find('Sometime next week call the bank');
    expect(found.days.map((d) => d.kind), equals([DayKind.unsupported, DayKind.unsupported]));
    final r = _resolve('Sometime next week call the bank');
    expect(r.date, isNull);
    expect(r.flags, contains(ReviewFlag.chooseDate));
  });

  test('numbers that are not times are not candidates', () {
    expect(_find('I bought three laptops for the team').isEmpty, isTrue);
    expect(_find('We need 3 chairs').isEmpty, isTrue);
  });

  test('explicit dates, past dates and invalid dates', () {
    expect(_resolve('on 21 September').date, equals(const DueDate(2026, 9, 21)));
    expect(_resolve('September 21st, 2026').date, equals(const DueDate(2026, 9, 21)));
    final march = _resolve('by 3 March');
    expect(march.date, equals(const DueDate(2027, 3, 3)));
    expect(march.flags, contains(ReviewFlag.checkDate));
    expect(_resolve('on 30 February').flags, contains(ReviewFlag.chooseDate));
    expect(_resolve('on 1 January 2020').flags, contains(ReviewFlag.timePassed));
  });

  test('numeric dates are read day-first and flagged when ambiguous', () {
    final r = _resolve('due 5/10');
    expect(r.date, equals(const DueDate(2026, 10, 5)));
    expect(r.flags, contains(ReviewFlag.checkDate));
    expect(_resolve('due 25/12').date, equals(const DueDate(2026, 12, 25)));
    expect(_resolve('due 12/25').date, equals(const DueDate(2026, 12, 25)));
  });

  test('weekday said on the same weekday asks which one', () {
    final r = _resolve('see you Thursday');
    expect(r.date, equals(const DueDate(2026, 9, 24)));
    expect(r.flags, contains(ReviewFlag.checkDate));
    expect(_resolve('next Monday').flags, contains(ReviewFlag.checkDate));
    expect(_resolve('on Monday').date, equals(const DueDate(2026, 9, 21)));
  });

  test('relative durations use the capture time', () {
    expect(
      _resolve('remind me in 20 minutes').date,
      equals(const DueDate(2026, 9, 17, hour: 20, minute: 29)),
    );
    expect(
      _resolve('in half an hour').date,
      equals(const DueDate(2026, 9, 17, hour: 20, minute: 39)),
    );
    expect(_resolve('in 3 days').date, equals(const DueDate(2026, 9, 20)));
  });

  test('a time already passed today is flagged; a bare time rolls forward', () {
    expect(_resolve('today at 9am').flags, contains(ReviewFlag.timePassed));
    final bare = _resolve('at 9am');
    expect(bare.date, equals(const DueDate(2026, 9, 18, hour: 9, minute: 0)));
    expect(bare.flags, contains(ReviewFlag.checkDate));
  });

  test('24-hour, noon and half past', () {
    expect(_resolve('tomorrow at 14:30').date?.hour, equals(14));
    expect(_resolve('tomorrow at 2:30').flags, contains(ReviewFlag.chooseAmPm));
    expect(_resolve('tomorrow at noon').date?.hour, equals(12));
    expect(_resolve('tomorrow at half past two').flags, contains(ReviewFlag.chooseAmPm));
  });

  test('daylight-saving gap and overlap are flagged', () {
    // 28 Mar 2027 01:30 does not exist in London; 25 Oct 2026 01:30 occurs twice.
    final gap = checkInstant(
      const .new(2027, 3, 28, hour: 1, minute: 30),
      _londonOffset,
      _captured,
    );
    expect(gap, contains(ReviewFlag.clockChange));
    final overlap = wallTimeInstants(const .new(2026, 10, 25, hour: 1, minute: 30), _londonOffset);
    expect(overlap, hasLength(2));
    expect(reminderInstant(const .new(2026, 10, 25, hour: 1, minute: 30), _londonOffset), isNull);
    expect(
      reminderInstant(const .new(2026, 9, 18, hour: 14, minute: 0), _londonOffset),
      equals(DateTime.utc(2026, 9, 18, 13)),
    );
  });

  test('candidate offsets are absolute transcript offsets', () {
    const transcript = 'Hello there. Remind me tomorrow at 2pm.';
    final found = findDateCandidates(
      transcript,
      spanOf(transcript, 13, transcript.length),
      prefix: 'T2',
    );
    final [day] = found.days;
    expect(day.id, equals('T2D1'));
    expect(transcript.substring(day.span.start, day.span.end), equals('tomorrow'));
  });
}
