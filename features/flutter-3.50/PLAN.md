# Flutter 3.50.0

Status: Complete

## Outcome + scope

Capture builds, analyzes and tests with Flutter 3.50.0, and the packages the freshness gate names are current. Non-goals: new features and any redesign of a screen.

## Repository context

Owners: `pubspec.yaml`, `pubspec.lock`, `l10n.yaml`, `analysis_options.yaml`, `codemagic.yaml`, `hard-eng.gates.json`, `macos/Runner.xcodeproj`, `lib/`, `test/`. Flutter's guide: https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui
Same cause: N/A — first move to this Flutter release.
Single source: The Flutter version is pinned in `codemagic.yaml` (two places, both changed); the Mac release workflow floats on stable by design and stays. The comment rule and the speed rules own the other edits; no copy of a value was added.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: The owner approved the move to Flutter 3.50.0 and the package updates. Nothing is pushed or merged by this work.

## Acceptance + steps

- [x] The app and tests use `material_ui` and no code imports `package:flutter/material.dart` → `dart fix --apply --code=migrate_design_widgets` changed 95 files; `dart analyze --fatal-infos .` reports no issues.
- [x] The generated localizations come out of the generator in final form → `l10n.yaml` writes `app_localizations.g.dart` with the generated header; `flutter pub get` and `flutter gen-l10n` leave `git status` clean.
- [x] Page changes keep the standard page of Flutter 3.50.0 → measured with a temporary widget test on the real router and removed after; the numbers are in Risks.
- [x] The speed rules pass → `test/core/async/in_order_test.dart::starts each step only after the step before it has finished` and `::stops at the first failure and rethrows that error`.
- [x] A reset deletes the secrets one by one and stops at a refused delete → `test/features/settings/repositories/settings_repository_test.dart::a reset deletes the secrets one after another, then erases the local data` and `::a reset stops at the first refused delete and keeps the local data`.
- [x] Reminder scheduling keeps its order and saved progress → `test/features/capture/repositories/capture_save_repository_test.dart` (existing cases).
- [x] The macOS tests gate loads the coverage archive → a sandboxed test host writes no coverage data, so the gate builds the macOS tests with `DebugCoverage.entitlements`; `xcrun xccov view --report` succeeds on the result.
- [x] Freshness is clean → `crypto`, `sqlite3`, `flutter_local_notifications`, `sherpa_onnx`, `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `go_router`, `go_router_builder`, `build_runner` and `freezed` updated; the freshness gate passes.

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
Evidence: `python3 .hooks/hard-eng.py check --plan-stage Complete --base origin/main` with Flutter 3.50.0 in a clean tree; `flutter test` passes; the iPhone gate and macOS gate are part of the check. Not checked: a Windows build, a real device, a release build.
E2E: N/A — no journey changes; the `CaptureApp` widget journeys in `test/app/capture_app_test.dart` pass on Flutter 3.50.0.
Retro: macOS coverage failed on a sandboxed test host → the macOS tests gate; the comment rule failed on files the move touched → the comment rule itself; the first iPhone gate run timed out under load → None — it passes alone.

Delivery target: Merge
Delivery: Pending — a merge to `main` publishes the next release; the owner opens the pull request.
