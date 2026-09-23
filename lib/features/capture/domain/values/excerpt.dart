import 'package:capture/core/domain/values/required_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'excerpt.freezed.dart';

/// Exact transcript text of a source span; never empty.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class Excerpt with _$Excerpt {
  const Excerpt._();

  const factory Excerpt._raw(String value) = _Excerpt;

  factory Excerpt(String value) => Excerpt._raw(requireText(value, 'Excerpt'));

  @override
  String toString() => value;
}
