# Flutter 3.50.0

Status: Complete

## Outcome + scope

Capture builds, analyzes and tests with Flutter 3.50.0, and the packages the freshness gate names are current. Non-goals: new features and any redesign of a screen.

## Repository context

Owners: `pubspec.yaml`, `pubspec.lock`, `l10n.yaml`, `analysis_options.yaml`, `codemagic.yaml`, `hard-eng.gates.json`, `macos/Runner.xcodeproj`, `lib/`, `test/`. Flutter's guide: https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui
Same cause: N/A — first move to this Flutter release. For the keychain fault: `KeychainSecretsLocalDatasource` is the only reader of the login keychain in `lib/`, and the iPhone test host runs in a simulator with its own keychain, so no other place has the fault.
Compiler fault: the Dart 3.14.0 compiler (`gen_snapshot`) stopped the macOS release build at `linearscan.cc` line 3013 (`UNREACHABLE()` in `FindCover`) while it compiled `NotionHttpService.uploadFile`; the same file is on the default branch. Moving the send step into `_sendFile` fixed it, and the next stop, `NotionWorkspaceRemoteDatasource._ensureDataSources`, ended once the library schema was built before its closure.
Keychain fault: the macOS tests gate starts a debug host app for each run, and the host ran the real app start, which read the login keychain. A debug build has a new signature each time, so macOS asked the developer before each read: 11 prompts in the system log of one working day, from 58 host starts. The default branch has the same fault. The test action of the Runner scheme now sets `CAPTURE_TEST_HOST`, and with it `secretsDatasourceFor` gives a store in memory.
Single source: The Flutter version is pinned in `codemagic.yaml` (two places, both changed); the Mac release workflow floats on stable by design and stays. The comment rule and the speed rules own the other edits; no copy of a value was added.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: The owner approved the move to Flutter 3.50.0 and the package updates. Nothing is pushed or merged by this work.

## Acceptance + steps

- [x] The app and tests use `material_ui` and no code imports `package:flutter/material.dart` → `test/app/capture_app_test.dart::first launch shows the setup steps and still records` runs the real app on `material_ui`; `dart fix --apply --code=migrate_design_widgets` changed 95 files and `dart analyze --fatal-infos .` reports no issues.
- [x] The generated localizations come out of the generator in final form → N/A — a generated file has no test; `l10n.yaml` writes `app_localizations.g.dart` with the generated header, and `flutter pub get` plus `flutter gen-l10n` leave `git status` clean.
- [x] Page changes keep the standard page of Flutter 3.50.0 → N/A — a temporary widget test on the real router measured it and was removed; the numbers are in Risks.
- [x] Ordered work keeps its order and stops at the first failure → `test/core/async/in_order_test.dart::starts each step only after the step before it has finished` and `test/core/async/in_order_test.dart::stops at the first failure and rethrows that error`.
- [x] A reset deletes the secrets one by one and stops at a refused delete → `test/features/settings/repositories/settings_repository_test.dart::a reset deletes the secrets one after another, then erases the local data` and `test/features/settings/repositories/settings_repository_test.dart::a reset stops at the first refused delete and keeps the local data`.
- [x] Reminder scheduling keeps its order and saved progress → `test/features/capture/repositories/capture_save_repository_test.dart::a scheduled reminder is recorded on the stored capture` and `test/features/capture/repositories/capture_save_repository_test.dart::a capture deleted while the reminder prompt was open is not written back`.
- [x] The macOS tests gate loads the coverage archive → N/A — the gate command is the proof: a sandboxed test host writes no coverage data, so the gate builds the macOS tests with `DebugCoverage.entitlements`, and `xccov` then succeeds.
- [x] Freshness is clean → N/A — the freshness gate is the proof; `crypto`, `sqlite3`, `flutter_local_notifications`, `sherpa_onnx`, `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `go_router`, `go_router_builder`, `build_runner` and `freezed` are updated.
- [x] The macOS release build compiles with the Dart 3.14.0 compiler, and the Notion file upload keeps its behaviour → N/A — no test runs the release compiler; `gen_snapshot_arm64` and `gen_snapshot_x64` on the `--tfa` kernel of `package:capture/main.dart` end with exit 0 (the same step `flutter build macos --release` runs), and the upload behaviour is proven by `test/core/data/notion/notion_http_service_test.dart::uploadFile creates a single part upload, sends the file and returns the id`, `uploadFile with a create answer without an id is an invalid request and sends nothing`, `uploadFile with a rejected create call returns that failure and sends nothing`, `uploadFile without a stored token is an invalid token and makes no request` and `uploadFile with a rejected send call returns that failure`.
- [x] The host app of the macOS native tests keeps secrets in memory and makes no keychain call, and a normal run still reads the keychain → `test/core/data/secrets/secrets_local_datasource_test.dart::the host app of the native tests keeps secrets in memory and makes no keychain call`, `test/core/data/secrets/secrets_local_datasource_test.dart::a normal run reads each secret from the keychain`, `test/core/data/secrets/secrets_local_datasource_test.dart::the test action of the Runner scheme gives its host app the test host variable` and `macos/RunnerTests/RunnerTests.swift::testHostAppCarriesTheVariableThatKeepsSecretsOutOfTheKeychain`.

## Baseline + execution

Result: Passed
Evidence: On Flutter 3.50.0 before any change, `dart analyze --fatal-infos .` reported 98 issues (96 `deprecated_member_use`, 1 `avoid_redundant_argument_values`, plus one more deprecation line); `flutter test` passed 162 tests.
Execution: One builder in one work tree, one commit per concern.

## Risks + recovery

Screen change motion can differ. Before the move the router found no Material app and gave every route a page with no transition. After it, go_router gives `MaterialPage`. Measured with the real router, 16 ms steps, time until the old screen is out of view (Flutter 3.47.5 before, 3.50.0 after):

| Route change | Page type before | Page type after | Before (ms) | After (ms) | After, animations off (ms) |
| --- | --- | --- | --- | --- | --- |
| Home to Groups, Groups to Recordings, Editor to Settings, Settings to Home | NoTransitionPage | MaterialPage | 0 | 304 | 16 |
| Recordings to Editor (pushed on top) | NoTransitionPage | MaterialPage | 0 | 304 | 16 |

The shell is built once at launch, so there is no change into a shell. No route has its own page, so the standard page stays and no code changed. The sidebar and tab changes now slide for about 0.3 s. Recovery: give each route a `pageBuilder` that returns `NoTransitionPage`.

`sherpa_onnx` 2 changes the NeMo mel features to match NeMo (the same on normal audio, better on very quiet audio). The Parakeet model was not run here. Recovery: pin `sherpa_onnx` 1.13.8 again.

## ux_reference

N/A — no screen is redrawn; only imports, packages and tests change. The one visible difference is the page motion named in Risks.

## Verification

Result: Passed
Evidence: `python3 .hooks/hard-eng.py check --plan-stage Complete --base origin/main` with Flutter 3.50.0 in a clean tree; `flutter test` passes; the iPhone gate and macOS gate are part of the check. After the keychain repair one real run of the macOS tests gate passed 39 native tests; the system log held no keychain request of the host app and no prompt window opened. `flutter build macos --release` with Flutter 3.50.0 ends with exit 0 and builds the app. Not checked: a Windows build, a real device, a start of the release app.
E2E: N/A — no journey changes; the `CaptureApp` widget journeys in `test/app/capture_app_test.dart` pass on Flutter 3.50.0.
Retro: macOS coverage failed on a sandboxed test host → the macOS tests gate; the comment rule failed on files the move touched → the comment rule itself; the first iPhone gate run timed out under load → None — it passes alone; the macOS release build stopped in the Dart compiler and ran first in CI, not before the push → run `flutter build macos --release` before the push; the native test host read the developer's real keychain and macOS showed a prompt for each read (found by the owner, also on the default branch; no gate can see a prompt on a screen) → the three tests of `test/core/data/secrets/secrets_local_datasource_test.dart` and the native host test, which fail on the revision before the repair.

Delivery target: Merge
Delivery: Pending — a merge to `main` publishes the next release; the owner opens the pull request.
