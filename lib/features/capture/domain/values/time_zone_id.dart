import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_zone_id.freezed.dart';

/// IANA time zone name, such as `Europe/London`.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class TimeZoneId with _$TimeZoneId {
  const TimeZoneId._();

  const factory TimeZoneId._raw(String value) = _TimeZoneId;

  factory TimeZoneId(String value) => TimeZoneId._raw(requireText(value, 'TimeZoneId'));

  @override
  String toString() => value;
}
