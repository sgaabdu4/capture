import 'dart:convert';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/features/settings/data/models/shortcut_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shortcut_local_datasource.g.dart';

abstract interface class IShortcutLocalDatasource {
  ShortcutModel? read();
  void write(ShortcutModel shortcut);
}

@Riverpod(keepAlive: true)
IShortcutLocalDatasource shortcutLocalDatasource(Ref ref) =>
    ShortcutLocalDatasource(ref.read(keyValueLocalDatasourceProvider));

class ShortcutLocalDatasource implements IShortcutLocalDatasource {
  ShortcutLocalDatasource(this._kv);
  final IKeyValueLocalDatasource _kv;

  static const _key = 'shortcut';

  @override
  ShortcutModel? read() => switch (_kv.read(_key)) {
    final String raw => _decode(raw),
    null => null,
  };

  static ShortcutModel? _decode(String raw) => switch (jsonDecode(raw)) {
    final Map<String, dynamic> json => .fromJson(json),
    _ => null,
  };

  @override
  void write(ShortcutModel shortcut) => _kv.write(_key, jsonEncode(shortcut.toJson()));
}
