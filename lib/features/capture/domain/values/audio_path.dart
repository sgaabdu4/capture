import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_path.freezed.dart';

/// Path of a capture's recorded audio file.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class AudioPath with _$AudioPath {
  const AudioPath._();

  const factory AudioPath._raw(String value) = _AudioPath;

  factory AudioPath(String value) => AudioPath._raw(requireText(value, 'AudioPath'));

  @override
  String toString() => value;
}
