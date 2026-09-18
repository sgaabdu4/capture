/// Kinds of day expression. Supported language: English.
enum DayKind { today, tomorrow, dayAfter, weekday, explicit, numeric, inDays, unsupported }

/// Kinds of time expression.
enum TimeKind { exact, ambiguous, inMinutes }

/// Part of the day named next to a day or time ("tomorrow morning",
/// "at 2 in the afternoon").
enum DayPeriod { none, morning, afternoon, evening }
