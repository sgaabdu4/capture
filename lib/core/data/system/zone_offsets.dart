import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:timezone/timezone.dart' as tz;

UtcOffsetAt zoneOffsets(String timeZone) {
  final location = tz.getLocation(timeZone);
  return (instantUtc) => location.timeZone(instantUtc.millisecondsSinceEpoch).offset;
}
