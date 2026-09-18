import '../models.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', //
  'Saturday', 'Sunday',
];

/// "2:00 PM".
String formatTime(int hour, int minute) {
  final h = hour % 12 == 0 ? 12 : hour % 12;
  return '$h:${minute.toString().padLeft(2, '0')} ${hour < 12 ? 'AM' : 'PM'}';
}

/// Human date relative to [today] (a wall-clock date in the same zone):
/// "Today 3:00 PM", "Tomorrow", "Friday 10:00 AM", "21 Sep", "3 Jan 2027".
String formatDue(DueDate date, DateTime today) {
  final d = DateTime.utc(date.year, date.month, date.day);
  final t = DateTime.utc(today.year, today.month, today.day);
  final days = d.difference(t).inDays;
  final day = switch (days) {
    0 => 'Today',
    1 => 'Tomorrow',
    -1 => 'Yesterday',
    > 1 && < 7 => _weekdays[d.weekday - 1],
    _ =>
      '${date.day} ${_months[date.month - 1]}'
          '${date.year == today.year ? '' : ' ${date.year}'}',
  };
  return date.hasTime
      ? '$day ${formatTime(date.hour!, date.minute ?? 0)}'
      : day;
}

/// "Just now", "5 minutes ago", "2 hours ago", "Yesterday", "3 days ago".
String formatAgo(DateTime then, DateTime now) {
  final diff = now.difference(then);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  }
  if (diff.inDays == 1) return 'Yesterday';
  return '${diff.inDays} days ago';
}

/// "0:42" / "4:05".
String formatDuration(double seconds) {
  final s = seconds.round();
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}
