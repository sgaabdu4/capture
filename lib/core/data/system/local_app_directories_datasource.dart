import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_app_directories_datasource.g.dart';

/// Where Capture keeps its files inside its sandbox container.
typedef AppDirectories = ({String captures, String model, String database});

const _homeVariable = 'HOME';

/// Application Support inside the sandbox container (`$HOME` is the
/// container's Data folder), matching `NSApplicationSupportDirectory`.
@Riverpod(keepAlive: true)
AppDirectories appDirectories(Ref ref) {
  const bundleId = 'com.abid.capture';
  final home = Platform.environment[_homeVariable] ?? Directory.systemTemp.path;
  final support = '$home/Library/Application Support/$bundleId';
  return (
    captures: '$support/captures',
    model: '$support/models/parakeet-tdt-0.6b-v3-int8',
    database: '$support/capture.sqlite',
  );
}
