import 'package:capture/core/domain/values/byte_size.dart';
import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/capture/domain/values/audio_path.dart';
import 'package:capture/features/capture/domain/values/capture_id.dart';
import 'package:capture/features/capture/domain/values/excerpt.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';
import 'package:capture/features/capture/domain/values/jev_model.dart';
import 'package:capture/features/capture/domain/values/jev_state.dart';
import 'package:capture/features/capture/domain/values/passage_id.dart';
import 'package:capture/features/capture/domain/values/time_zone_id.dart';
import 'package:capture/features/groups/domain/values/group_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requiredText = <String, Object Function(String)>{
    'NotionId': NotionId.new,
    'CaptureId': CaptureId.new,
    'ItemId': ItemId.new,
    'TimeZoneId': TimeZoneId.new,
    'AudioPath': AudioPath.new,
    'JevModel': JevModel.new,
    'JevState': JevState.new,
    'PassageId': PassageId.new,
    'Excerpt': Excerpt.new,
    'GroupName': GroupName.new,
  };

  for (final MapEntry(key: name, value: make) in requiredText.entries) {
    test('$name rejects blank text and keeps other text exactly', () {
      expect(() => make(''), throwsA(isA<AssertionError>()));
      expect(() => make(' \n'), throwsA(isA<AssertionError>()));
      expect(make(' Work ').toString(), equals(' Work '));
    });
  }

  test('ByteSize rejects a negative size', () {
    expect(() => ByteSize.fromBytes(-1), throwsA(isA<AssertionError>()));
    expect(ByteSize.fromBytes(0).inBytes, equals(0));
  });
}
