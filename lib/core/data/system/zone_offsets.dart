import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:timezone/timezone.dart' as tz;

/// The UTC offset rules of an IANA zone (e.g. `Europe/London`), from the
/// bundled time zone database.
UtcOffsetAt zoneOffsets(String timeZone) {
  final location = tz.getLocation(timeZone);
  return (instantUtc) => location.timeZone(instantUtc.millisecondsSinceEpoch).offset;
}
