import 'dart:io';

import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const keychain = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      keychain,
      (call) async {
        calls.add(call);
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      keychain,
      null,
    );
  });

  test(
    'the host app of the native tests keeps secrets in memory and makes no keychain call',
    () async {
      final secrets = secretsDatasourceFor({testHostVariable: '1'});

      await secrets.write(.notionToken, 'token');
      expect(await secrets.read(.notionToken), 'token');
      expect(await secrets.read(.typesafeKey), isNull);
      await secrets.delete(.notionToken);
      expect(await secrets.read(.notionToken), isNull);

      expect(calls, isEmpty);
    },
  );

  test('a normal run reads each secret from the keychain', () async {
    await secretsDatasourceFor(const {}).read(.notionToken);

    expect(calls.map((call) => call.method), ['read']);
    expect(calls.single.arguments, containsPair('key', 'notionToken'));
  });

  test('the test action of the Runner scheme gives its host app the test host variable', () {
    final scheme = File('macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme')
        .readAsStringSync();
    final testAction = scheme.substring(
      scheme.indexOf('<TestAction'),
      scheme.indexOf('</TestAction>'),
    );

    expect(testAction, contains('shouldUseLaunchSchemeArgsEnv = "NO"'));
    expect(testAction, contains('key = "$testHostVariable"'));
  });
}
