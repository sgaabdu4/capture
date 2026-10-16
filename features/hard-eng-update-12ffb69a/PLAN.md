# Hard Eng 12ffb69a update

Status: Ready

## Outcome + scope

The repo runs Hard Eng `12ffb69a` and passes its new Swift checks for the `ios/` and `macos/` Xcode projects: swift-format strict lint, `xcodebuild test` with at least 70% line coverage, Semgrep Swift rules and duplicate detection. Out of scope: app behaviour, release signing, dependency updates.

## Repository context

Owners: `.hooks/hard-eng-source.json` and the updater commit (installed revision); `hard-eng.gates.json` (the `ios` and `macos` groups the update added); `ios/` and `macos/` Swift and their `RunnerTests` folders (formatting, tests); `ios/Runner.xcodeproj` (a `CaptureControlsTests` target, because the Control Centre extension is not loaded by `RunnerTests`); `.github/workflows/release.yml` (the `hard-eng` job now needs a macOS runner for Xcode, so an `impact` job picks the runner as in Hard Eng's generated workflow). The iPhone app compiles `macos/Runner/Native/Recorder.swift` and `M4AEncoder.swift`, so those files are covered through the `macos` group.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Agent-loop under the owner's Hard Eng update request: update to `12ffb69a`, fix what the new Swift checks report in the repo, merge when CI is green. Nothing is suppressed, excluded or lowered.

## Acceptance + steps

- [ ] Installed revision is `12ffb69a` → `.hooks/hard-eng-source.json` shows `12ffb69ac2317ee14634bec1593732d878c7647b`.
- [ ] Swift sources pass `swift format lint --strict` → `swift format` applied to the files it flagged; multi-line Swift comments shortened to one line in the files touched.
- [ ] Both Swift groups declare their reviewed `performance_exception` and `depends_on` → the Swift code runs once per recording and Hard Eng reads no Swift performance report; the Flutter work around it has its own performance suite.
- [ ] `macos` and `ios` tests reach 70% line coverage → real XCTest suites replace the template stubs: the plugin bridge, M4A encoder, hotkey, overlay, menu and theme on macOS; the plugin bridge, record requests, shortcuts and the Control Centre extension on iPhone.
- [ ] The Control Centre extension is loaded by a test → a `CaptureControlsTests` target compiles `CaptureControls.swift` and `RecordWithCaptureIntent.swift` and is a testable of the `Runner` scheme.
- [ ] `hard-eng` CI runs Swift checks on macOS → `impact` job output picks `macos-latest` when a Swift group is selected; the job is never skipped; the mise package name no longer uses bash 4 lowercasing.

## Baseline + execution

Result: Passed
Evidence: Starting point `5a1ac78` on Hard Eng `1c855849` passed the required `hard-eng` check in CI when PR #34 merged. After the updater commit, `check` stopped at the missing `performance_exception` on the new Swift groups, and swift-format reported 33 findings in 7 files.
Execution: Single builder; updater commit, format commit, workflow edit, tests.

## Risks + recovery

The iPhone tests need an iOS 26 simulator, which this Mac lacks, so they run first on the pull request's macOS runner; the pull request checks run them before merge. A failing runner image would block the `hard-eng` job, not the app. Recovery = revert the PR.

## ux_reference

N/A — tooling and tests only; no app screens change.

## Verification

Result: Pending
Evidence: Pending.
E2E: N/A — no user journey changes; Swift behaviour is verified by the native XCTest suites.

Delivery target: Merge
Delivery: Pending — PR merged into main with the required `hard-eng` and `dmg` checks passing on the merged revision.
