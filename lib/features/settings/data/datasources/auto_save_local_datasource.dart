import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_save_local_datasource.g.dart';

/// Whether auto-save is on; off when never set.
abstract interface class IAutoSaveLocalDatasource {
  bool get on;
  set on(bool value);
}

@Riverpod(keepAlive: true)
IAutoSaveLocalDatasource autoSaveLocalDatasource(Ref ref) =>
    AutoSaveLocalDatasource(ref.read(keyValueLocalDatasourceProvider));

class AutoSaveLocalDatasource implements IAutoSaveLocalDatasource {
  AutoSaveLocalDatasource(this._kv);
  final IKeyValueLocalDatasource _kv;

  static const _key = 'autoSave';
  static const _stored = 'true';

  @override
  bool get on => _kv.read(_key) == _stored;

  @override
  set on(bool value) => _kv.write(_key, value ? _stored : null);
}
