import 'dart:math';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'system_datasource.g.dart';

/// Clock, time zone and id source; replaced by fixed values in tests.
abstract interface class ISystemDatasource {
  DateTime nowUtc();

  /// The Mac's current IANA zone, e.g. `Europe/London`.
  Future<String> timeZone();

  /// Random, URL-safe id for captures and items.
  String newId();
}

@Riverpod(keepAlive: true)
ISystemDatasource systemDatasource(Ref ref) => SystemDatasource(.secure());

class SystemDatasource implements ISystemDatasource {
  SystemDatasource(this._random);
  final Random _random;

  static const _idBytes = 12;
  static const _hexRadix = 16;
  static const _byteValues = 256;
  static const _hexDigits = 2;

  @override
  DateTime nowUtc() => .now().toUtc();

  @override
  Future<String> timeZone() async => (await FlutterTimezone.getLocalTimezone()).identifier;

  @override
  String newId() => [
    for (int i = 0; i < _idBytes; i++)
      _random.nextInt(_byteValues).toRadixString(_hexRadix).padLeft(_hexDigits, '0'),
  ].join();
}
