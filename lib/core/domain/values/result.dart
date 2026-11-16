import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@Freezed(map: .none, when: .none)
sealed class Result<T, E> with _$Result<T, E> {
  const Result._();

  const factory Result.ok(T value) = Ok<T, E>;
  const factory Result.err(E failure) = Err<T, E>;

  /// The value, or null for a failure.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };
}
