/// Kinds of day expression. Supported language: English.
enum DayKind { today, tomorrow, dayAfter, weekday, explicit, numeric, inDays, unsupported }

/// Kinds of time expression.
enum TimeKind { exact, ambiguous, inMinutes }

enum DayPeriod { none, morning, afternoon, evening }
