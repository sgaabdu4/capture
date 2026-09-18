import 'package:capture/core/crash/crash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _secret = 'Remind me to call Sam about the diagnosis';

void main() {
  final printed = <String>[];
  final original = debugPrint;

  setUp(() {
    printed.clear();
    debugPrint = (message, {wrapWidth}) => printed.add(message ?? '');
  });
  tearDown(() => debugPrint = original);

  test('an uncaught error is logged by type only, never its message', () {
    Crash.error(const FormatException(_secret), .empty);

    expect(printed.join('\n'), contains('FormatException'));
    expect(printed.join('\n'), isNot(contains(_secret)));
  });
}
