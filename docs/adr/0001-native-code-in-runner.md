# 0001 — Native macOS code lives in the Runner target

Status: Accepted

## Context
The global shortcut, recorder, overlay pill, review card, menu-bar popover and M4A encoder were a nested Flutter plugin package (`packages/capture_native`). The Hard Eng update to fcd7d8b requires a full gate group (format, types, tests, dead code, boundaries, performance) for every nested Dart package, and its setup rejects analyzer excludes for project files. The package's only Dart was a channel-name constant.

## Decision
Keep the Swift in `macos/Runner/Native/` as part of the Runner target. `MainFlutterWindow` registers `CaptureNativePlugin` directly. The Dart side is `lib/core/services/native_platform_service.dart`, and the channel name is `NativeChannelKeys.channel`. No nested packages.

## Consequences
One Dart package and one gate group; root analysis covers all Dart with the lint plugins active. New Swift files must be added to the Runner target in `project.pbxproj`. Native behaviour is unchanged.

## Evidence
The owner chose "Fold into app" when the update failed. The moved Swift typechecks against FlutterMacOS. Still pending: a full `flutter build macos` and a successful re-run of the Hard Eng updater once the migration is committed.
