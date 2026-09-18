import 'package:capture/features/settings/domain/entities/speech_model_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_model_event.freezed.dart';

/// Progress of the one-time Parakeet download.
@Freezed(map: .none, when: .none)
sealed class SpeechModelEvent with _$SpeechModelEvent {
  const factory SpeechModelEvent.progress({required int received, required int total}) =
      SpeechModelProgress;
  const factory SpeechModelEvent.verifying(String file) = SpeechModelVerifying;
  const factory SpeechModelEvent.ready() = SpeechModelReady;
  const factory SpeechModelEvent.failed(SpeechModelFailure reason) = SpeechModelFailed;
}
