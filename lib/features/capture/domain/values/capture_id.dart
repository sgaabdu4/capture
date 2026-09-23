import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_id.freezed.dart';

/// Id of one voice capture, made by code when recording starts.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class CaptureId with _$CaptureId {
  const CaptureId._();

  const factory CaptureId._raw(String value) = _CaptureId;

  factory CaptureId(String value) => CaptureId._raw(requireText(value, 'CaptureId'));

  @override
  String toString() => value;
}
