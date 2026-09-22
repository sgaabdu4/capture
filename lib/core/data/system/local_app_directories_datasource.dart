import 'dart:io';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_app_directories_datasource.g.dart';

/// Where Capture keeps its files inside its sandbox container.
typedef AppDirectories = ({String captures, String model, String database});

const _homeVariable = 'HOME';

/// Application Support inside the sandbox container, matching
/// `NSApplicationSupportDirectory`. On the Mac `$HOME` is the container's
/// Data folder; iPhone apps have no `$HOME`, and their temporary folder is
/// `tmp` inside the container.
@Riverpod(keepAlive: true)
AppDirectories appDirectories(Ref ref) {
  const bundleId = 'com.afenso.capture';
  final home = Platform.environment[_homeVariable] ?? Directory.systemTemp.parent.path;
  final support = '$home/Library/Application Support/$bundleId';
  return (
    captures: '$support/captures',
    model: ref.read(systemDatasourceProvider).isPhone
        ? '$support/models/parakeet-tdt-0.6b-v3-coreml'
        : '$support/models/parakeet-tdt-0.6b-v3-int8',
    database: '$support/capture.sqlite',
  );
}
