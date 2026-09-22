# iPhone TestFlight setup

Status: Complete

## Outcome + scope

Codemagic can sign and upload Capture for iPhone to TestFlight with the owner's existing App Store Connect key. iPhone-only changes no longer publish a Mac release, and Mac-only changes no longer run the iPhone build. The app version becomes 1.0.0 so the iPhone build matches App Store version 1.0. Out of scope: the App Store listing, review submission and any app code.

## Repository context

Owners: `codemagic.yaml` (iPhone builds and TestFlight upload), `.github/workflows/release.yml` (`changes` job: builds the Mac DMG on pull requests and publishes a Mac release on `main` when anything other than docs changed).
Account state, set up 2026-09-23 with the owner's approval:
- Apple Developer: explicit App IDs `com.afenso.capture` and `com.afenso.capture.CaptureControls` (no capabilities; `ios/` has no entitlements), and App Store profiles "Capture App Store" and "Capture Controls App Store" from the Afenso Ltd distribution certificate.
- App Store Connect: app "Capture: Voice to Tasks" (Apple ID 6814996477, SKU `capture-ios`, English (U.K.)).
- Codemagic: the profiles are stored as `capture_app_store` and `capture_controls_app_store`, alongside the existing `appstore` distribution certificate. The existing App Store Connect key integration is named `codemagic`. The `capture` repository has been added as a Codemagic app.
`ios/Runner/Info.plist` already declares `ITSAppUsesNonExemptEncryption` false.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the owner asked for the App Store release setup ("do what you need to do now"), chose the name "Capture: Voice to Tasks", and asked to skip the Mac release for iPhone-only changes "and vice versa". Keep the repository MIT and public; no credentials in the repository. Later on 2026-09-23 the owner asked to update the version to match App Store version 1.0 ("Update it") and approved the merge ("merge it"), knowing it publishes one Mac release; the owner is the release approver.

## Acceptance + steps

- [x] A1 `ios-testflight` uses the existing integration `codemagic` and `APP_STORE_APPLE_ID: 6814996477`. Proof: diff review. The first manual Codemagic run proves signing and upload (there is no local validator for `codemagic.yaml`).
- [x] A2 The Mac `changes` filter treats `ios/` and `codemagic.yaml` like documentation: only those changes → `app=false` (no DMG, no release); any other change → `app=true`. Proof: the workflow's exact pattern run in bash against sample file lists (iPhone-only, docs-only, mixed, `lib/`, `macos/`, `pubspec.yaml`, `assets/`). This PR changes `release.yml` itself, so it still builds the DMG, and merging it publishes one Mac release; iPhone-only changes after it do not.
- [x] A3 `ios-validate` skips pull requests that change only `macos/` or Markdown files (Codemagic `when: changeset` excludes). Proof: diff review against Codemagic's changeset syntax; the first Mac-only PR shows the skip.
- [x] A4 `pubspec.yaml` version is `1.0.0+1`, so the next iPhone build reports 1.0.0 (the build number is still set by Codemagic from TestFlight) and matches App Store version 1.0. The Mac release name follows the same version (`1.0.0-alpha.N`). Proof: diff review; the next TestFlight build shows version 1.0.0.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `origin/main` (b393889) with only this plan added: `python3 .hooks/hard-eng.py check --plan-stage Draft --base 4b825dc642cb6eb9a060e54bf8d69288fbee4904` → 14/14 PASS, exit 0.
Execution: One builder; two small file edits, then PR.

## Risks + recovery

- A path missed in the Mac filter would skip a needed Mac release. Recovery: the filter only treats `ios/` and `codemagic.yaml` as non-Mac; `lib/`, `pubspec.*`, `assets/` and `macos/` still release.
- Codemagic may not pick the extension's profile from `bundle_identifier: com.afenso.capture`. Recovery: the first TestFlight run shows it; then list both identifiers in `ios_signing`.

## ux_reference

N/A — build and release configuration only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `feature/ios-testflight-setup`.
- Mac filter: the pattern copied from `release.yml` and run in bash gave the expected result in all 8 cases. iPhone-only → false; docs and plans → false; this PR's files → true; `ios/` + `lib/` → true; `lib/`, `macos/`, `pubspec.yaml` and `assets/` → true. A first test in zsh gave wrong results; that was the test harness, not the pattern, and the workflow runs bash.
- `codemagic.yaml`: diff reviewed. The integration name `codemagic` matches the key listed in Codemagic's Developer Portal integration. The Apple ID matches the App Store Connect URL `apps/6814996477`. `when: changeset` follows Codemagic's documented `includes: ['.']` plus `excludes` form.
- Version: `pubspec.yaml` diff reviewed; nothing else in `lib/`, `test/`, `ios/`, `macos/` or `.github/` hard-codes 0.1.0.
- Gates: `python3 .hooks/hard-eng.py check --plan-stage Complete` → 14/14 PASS (final run recorded in the commit's check).
E2E: N/A — configuration only. The TestFlight upload is proven by the first manual Codemagic run, recorded under Delivery.

Delivery target: Merge
Delivery: Pending — merge to `main` after Hard Eng CI passes. Before this change, a manual `ios-testflight` run from this branch signed both targets and uploaded build 1 (0.1.0) to TestFlight.
