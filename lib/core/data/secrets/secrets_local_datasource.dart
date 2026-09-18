import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secrets_local_datasource.g.dart';

enum Secret { typesafeKey, notionToken }

/// Credential storage. Values never touch preferences, SQLite, logs or
/// Notion.
abstract interface class ISecretsLocalDatasource {
  Future<String?> read(Secret secret);
  Future<void> write(Secret secret, String value);
  Future<void> delete(Secret secret);
}

@Riverpod(keepAlive: true)
ISecretsLocalDatasource secretsLocalDatasource(Ref ref) => const KeychainSecretsLocalDatasource();

/// macOS login keychain (legacy file-based keychain: the data-protection
/// keychain needs a provisioning profile for a sandboxed, ad-hoc-signed
/// build).
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
