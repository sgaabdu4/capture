import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Secret { typesafeKey, notionToken }

/// Credential storage. The app uses the macOS Keychain; tests use memory.
abstract interface class SecretStore {
  Future<String?> read(Secret secret);
  Future<void> write(Secret secret, String value);
  Future<void> delete(Secret secret);
}

/// macOS login keychain (legacy file-based keychain: the data-protection
/// keychain needs a provisioning profile for a sandboxed, ad-hoc-signed
/// build). Values never touch preferences, SQLite, logs or Notion.
class KeychainSecrets implements SecretStore {
  const KeychainSecrets();

  static const _storage = FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );

  @override
  Future<String?> read(Secret secret) => _storage.read(key: secret.name);

  @override
  Future<void> write(Secret secret, String value) =>
      _storage.write(key: secret.name, value: value);

  @override
  Future<void> delete(Secret secret) => _storage.delete(key: secret.name);
}

class MemorySecrets implements SecretStore {
  final _values = <Secret, String>{};

  @override
  Future<String?> read(Secret secret) async => _values[secret];

  @override
  Future<void> write(Secret secret, String value) async =>
      _values[secret] = value;

  @override
  Future<void> delete(Secret secret) async => _values.remove(secret);
}
