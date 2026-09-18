import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

const _daysPerWeek = 7;
const _secondDigits = 2;

extension DueDateFormat on DueDate {
  /// Relative to [today] (a wall-clock date in the same zone): "Today 3:00 PM",
  /// "Tomorrow", "Friday 10:00 AM", "21 Sep", "3 Jan 2027".
  String label(AppLocalizations l10n, DateTime today) {
    final date = DateTime.utc(year, month, day);
    final days = date.difference(.utc(today.year, today.month, today.day)).inDays;
    final dayLabel = switch (days) {
      0 => l10n.dayToday,
      1 => l10n.dayTomorrow,
      -1 => l10n.dayYesterday,
      > 1 && < _daysPerWeek => DateFormat.EEEE(l10n.localeName).format(date),
      _ when year == today.year => DateFormat('d MMM', l10n.localeName).format(date),
      _ => DateFormat('d MMM y', l10n.localeName).format(date),
    };
    return switch (timeLabel(l10n)) {
      final String time => l10n.dayWithTime(dayLabel, time),
      null => dayLabel,
    };
  }

  /// "2:00 PM", or null for a date-only value.
  String? timeLabel(AppLocalizations l10n) => switch ((h: hour, m: minute)) {
    (h: final int h, m: final int m) => _clock(l10n, h, m),
    (h: final int h, m: null) => _clock(l10n, h, 0),
    (h: null, m: _) => null,
  };

  String _clock(AppLocalizations l10n, int h, int m) =>
      DateFormat.jm(l10n.localeName).format(.new(year, month, day, h, m));
}

extension DateTimeAgo on DateTime {
  /// "Just now", "5 minutes ago", "2 hours ago", "Yesterday", "3 days ago".
  String agoLabel(AppLocalizations l10n, DateTime now) {
    final Duration(:inMinutes, :inHours, :inDays) = now.difference(this);
    if (inMinutes < 1) return l10n.agoJustNow;
    if (inMinutes < Duration.minutesPerHour) return l10n.agoMinutes(inMinutes);
    if (inHours < Duration.hoursPerDay) return l10n.agoHours(inHours);
    if (inDays == 1) return l10n.agoYesterday;
    return l10n.agoDays(inDays);
  }
}

extension DurationClock on Duration {
  /// "0:42" / "4:05".
  String get clockLabel {
    final seconds = inSeconds.remainder(Duration.secondsPerMinute);
    return '$inMinutes:${seconds.toString().padLeft(_secondDigits, '0')}';
  }
}
