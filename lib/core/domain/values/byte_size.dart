import 'package:freezed_annotation/freezed_annotation.dart';

part 'byte_size.freezed.dart';

/// A size in bytes, such as Notion's upload limit.
@Freezed(map: .none, when: .none, copyWith: false)
sealed class ByteSize with _$ByteSize {
  const ByteSize._();

  const factory ByteSize._raw(int inBytes) = _ByteSize;

  factory ByteSize.fromBytes(int bytes) {
    assert(bytes >= 0, 'ByteSize must not be negative');
    return ByteSize._raw(bytes);
  }
}
