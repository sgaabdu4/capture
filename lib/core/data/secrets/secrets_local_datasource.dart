import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secrets_local_datasource.g.dart';

enum Secret { typesafeKey, notionToken }

/// Secret values never go to preferences, SQLite, logs or Notion.
abstract interface class ISecretsLocalDatasource {
  Future<String?> read(Secret secret);
  Future<void> write(Secret secret, String value);
  Future<void> delete(Secret secret);
}

const testHostVariable = 'CAPTURE_TEST_HOST';

@Riverpod(keepAlive: true)
ISecretsLocalDatasource secretsLocalDatasource(Ref ref) =>
    secretsDatasourceFor(Platform.environment);

// The host app of the native tests is a new debug build each time, so macOS asks the user before each keychain read.
ISecretsLocalDatasource secretsDatasourceFor(Map<String, String> environment) =>
    environment.containsKey(testHostVariable)
    ? MemorySecretsLocalDatasource()
    : const KeychainSecretsLocalDatasource();

class MemorySecretsLocalDatasource implements ISecretsLocalDatasource {
  final _values = <Secret, String>{};

  @override
  Future<String?> read(Secret secret) async => _values[secret];

  @override
  Future<void> write(Secret secret, String value) async => _values[secret] = value;

  @override
  Future<void> delete(Secret secret) async => _values.remove(secret);
}

/// The data protection keychain needs a provisioning profile, so this uses the login keychain.
class KeychainSecretsLocalDatasource implements ISecretsLocalDatasource {
  const KeychainSecretsLocalDatasource();

  static const _storage = FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );

  @override
  Future<String?> read(Secret secret) => _storage.read(key: secret.name);

  @override
  Future<void> write(Secret secret, String value) => _storage.write(key: secret.name, value: value);

  @override
  Future<void> delete(Secret secret) => _storage.delete(key: secret.name);
}
