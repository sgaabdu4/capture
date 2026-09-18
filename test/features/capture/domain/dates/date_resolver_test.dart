import 'package:capture/features/capture/domain/dates/date_candidates.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

late tz.Location london;

/// Thu 17 Sep 2026 20:09 in London (BST, UTC+1).
final captured = DateTime.utc(2026, 9, 17, 19, 9);

FoundCandidates find(String text) => findDateCandidates(text, SourceSpan.of(text, 0, text.length));

ResolvedDate resolve(String text, {int day = 0, int time = 0}) {
  final found = find(text);
  return resolveDate(
    capturedAtUtc: captured,
    location: london,
    day: day < 0 || found.days.isEmpty ? null : found.days[day],
    time: time < 0 || found.times.isEmpty ? null : found.times[time],
  );
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    london = tz.getLocation('Europe/London');
  });

  test('tomorrow at 2pm resolves against the capture time', () {
    final r = resolve('Remind me tomorrow at 2pm');
    expect(r.date, const DueDate(2026, 9, 18, hour: 14, minute: 0));
    expect(r.flags, isEmpty);
  });

  test('a correction yields two time candidates; the chosen one is used', () {
    const text = 'Buy groceries tomorrow at 2pm. Actually, make that 3pm.';
    final found = find(text);
    expect(found.times.map((t) => t.span.excerpt), ['2pm', '3pm']);
    expect(found.times.map((t) => t.id), ['H1', 'H2']);
    final r = resolve(text, time: 1);
    expect(r.date, const DueDate(2026, 9, 18, hour: 15, minute: 0));
  });

  test('tomorrow at two asks for AM/PM', () {
    final r = resolve('Call mum tomorrow at two');
    expect(r.flags, contains(ReviewFlag.chooseAmPm));
    expect(r.ambiguousHour, 2);
    expect(r.date, const DueDate(2026, 9, 18));
  });

  test('a period word resolves AM/PM', () {
    expect(resolve('Dinner tonight at 8').date, const DueDate(2026, 9, 17, hour: 20, minute: 0));
    expect(
      resolve('Call at 2 in the afternoon tomorrow').date,
      const DueDate(2026, 9, 18, hour: 14, minute: 0),
    );
  });

  test('finish by Friday is a date-only deadline', () {
    final r = resolve('Finish this by Friday', time: -1);
    expect(r.date, const DueDate(2026, 9, 18));
    expect(r.date!.hasTime, isFalse);
  });

  test('sometime next week keeps the wording and asks for a date', () {
    final found = find('Sometime next week call the bank');
    expect(found.days.map((d) => d.kind), [DayKind.unsupported, DayKind.unsupported]);
    final r = resolve('Sometime next week call the bank');
    expect(r.date, isNull);
    expect(r.flags, contains(ReviewFlag.chooseDate));
  });

  test('numbers that are not times are not candidates', () {
    expect(find('I bought three laptops for the team').isEmpty, isTrue);
    expect(find('We need 3 chairs').isEmpty, isTrue);
  });

  test('explicit dates, past dates and invalid dates', () {
    expect(resolve('on 21 September').date, const DueDate(2026, 9, 21));
    expect(resolve('September 21st, 2026').date, const DueDate(2026, 9, 21));
    final march = resolve('by 3 March');
    expect(march.date, const DueDate(2027, 3, 3));
    expect(march.flags, contains(ReviewFlag.checkDate));
    expect(resolve('on 30 February').flags, contains(ReviewFlag.chooseDate));
    expect(resolve('on 1 January 2020').flags, contains(ReviewFlag.timePassed));
  });

  test('numeric dates are read day-first and flagged when ambiguous', () {
    final r = resolve('due 5/10');
    expect(r.date, const DueDate(2026, 10, 5));
    expect(r.flags, contains(ReviewFlag.checkDate));
    expect(resolve('due 25/12').date, const DueDate(2026, 12, 25));
    expect(resolve('due 12/25').date, const DueDate(2026, 12, 25));
  });

  test('weekday said on the same weekday asks which one', () {
    final r = resolve('see you Thursday');
    expect(r.date, const DueDate(2026, 9, 24));
    expect(r.flags, contains(ReviewFlag.checkDate));
    expect(resolve('next Monday').flags, contains(ReviewFlag.checkDate));
    expect(resolve('on Monday').date, const DueDate(2026, 9, 21));
  });

  test('relative durations use the capture time', () {
    expect(
      resolve('remind me in 20 minutes').date,
      const DueDate(2026, 9, 17, hour: 20, minute: 29),
    );
    expect(resolve('in half an hour').date, const DueDate(2026, 9, 17, hour: 20, minute: 39));
    expect(resolve('in 3 days').date, const DueDate(2026, 9, 20));
  });

  test('a time already passed today is flagged; a bare time rolls forward', () {
    expect(resolve('today at 9am').flags, contains(ReviewFlag.timePassed));
    final bare = resolve('at 9am');
    expect(bare.date, const DueDate(2026, 9, 18, hour: 9, minute: 0));
    expect(bare.flags, contains(ReviewFlag.checkDate));
  });

  test('24-hour, noon and half past', () {
    expect(resolve('tomorrow at 14:30').date!.hour, 14);
    expect(resolve('tomorrow at 2:30').flags, contains(ReviewFlag.chooseAmPm));
    expect(resolve('tomorrow at noon').date!.hour, 12);
    expect(resolve('tomorrow at half past two').flags, contains(ReviewFlag.chooseAmPm));
  });

  test('daylight-saving gap and overlap are flagged', () {
    // 28 Mar 2027 01:30 does not exist in London; 25 Oct 2026 01:30 occurs twice.
    final gap = checkInstant(const DueDate(2027, 3, 28, hour: 1, minute: 30), london, captured);
    expect(gap, contains(ReviewFlag.clockChange));
    final overlap = wallTimeInstants(const DueDate(2026, 10, 25, hour: 1, minute: 30), london);
    expect(overlap, hasLength(2));
    expect(reminderInstant(const DueDate(2026, 10, 25, hour: 1, minute: 30), london), isNull);
    expect(
      reminderInstant(const DueDate(2026, 9, 18, hour: 14, minute: 0), london),
      DateTime.utc(2026, 9, 18, 13),
    );
  });

  test('candidate offsets are absolute transcript offsets', () {
    const transcript = 'Hello there. Remind me tomorrow at 2pm.';
    final found = findDateCandidates(
      transcript,
      SourceSpan.of(transcript, 13, transcript.length),
      prefix: 'T2',
    );
    final day = found.days.single;
    expect(day.id, 'T2D1');
    expect(transcript.substring(day.span.start, day.span.end), 'tomorrow');
  });
}
