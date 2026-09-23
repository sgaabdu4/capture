# Release versioning

Status: Complete

## Outcome + scope

Every merge to `main` that changes the app releases it on both platforms under one semantic version with no "alpha" suffix. The Mac DMG is published as GitHub release `vX.Y.Z`, and that tag starts the Codemagic TestFlight build of the same version. That build goes to TestFlight beta review and to App Store review, and is released automatically once Apple approves it. Each app-changing pull request must carry the App Store "What's New" text, and the release uses it.

Out of scope: app code, the Codemagic pull-request build, the Sparkle feed format, and the word "alpha" where README.md and PRODUCT.md describe the product stage.

## Repository context

- `.github/workflows/release.yml`
  - The `changes` job decides whether a push or PR touches the app. Today everything except top-level Markdown, plans, `ios/` and `codemagic.yaml` counts, so test and CI changes publish a release too.
  - The required `dmg` check builds on PRs.
  - The `release` job builds on push to `main` and waits for the hard-eng check. It then signs, notarises, writes the Sparkle feed and publishes `v<pubspec version>-alpha.<run>`.
- `codemagic.yaml` `ios-testflight` is started by hand. It numbers builds from the latest TestFlight build of the highest version, and only submits to TestFlight.
- Branch rules require the `hard-eng` and `dmg` checks. The workflow's concurrency group already runs pushes to `main` one at a time.
- Both apps read `CFBundleShortVersionString` from `FLUTTER_BUILD_NAME` and `CFBundleVersion` from `FLUTTER_BUILD_NUMBER`. `pubspec.yaml` says `1.0.0+1`. No plain `vX.Y.Z` tag exists yet; the newest is `v1.0.0-alpha.64`.
- App Store version 1.0 (build 4, 1.0.0) is Waiting for Review.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop.
- On 2026-09-23 the owner asked for both automations: "yes both pls and let's remove alpha name and let's use proper versioning pls".
- They chose "Every merge bumps patch (Recommended)".
- TestFlight: "should automatically release as well when approved".
- They accepted that this merge cancels the 1.0 review and resubmits: "Nah merge now and I don't mind a new version out lol and we can have a new build, why wait for apple lol and they can review the new version".
- What's New: "can we enforce a Appstore review text in prs and then use that potentially".

Decisions:
- **App changes** are `lib/`, `assets/`, `pubspec.yaml`, `pubspec.lock`, `l10n.yaml`, `macos/`, `ios/` and `codemagic.yaml`. Anything else (tests, CI, plans, docs, Hard Eng) builds and publishes nothing.
  - One filter covers both apps. A change to only one platform also rebuilds the other, which is harmless, and Codemagic's changeset filter is unreliable for tag builds.
  - `codemagic.yaml` counts, so this change releases itself. That merge is the real end-to-end test of the tag trigger.
- **Version** = the next patch after the newest plain `vX.Y.Z` tag, or the `pubspec.yaml` version if that is higher.
  - With no plain tag yet, the first release is 1.0.0, the version already in App Store review.
  - A minor or major release = raising the version in `pubspec.yaml` in a PR.
  - CI never commits the version back to `pubspec.yaml`. Builds take `--build-name` instead, and a bot push would start no workflows.
- The Mac build number stays the run number, which is what Sparkle compares. The iPhone build number is the highest build number across all versions + 1.
- **What's New** is the text under a `## What's New` heading in the PR description.
  - The `dmg` check fails an app-changing PR without it. Dependabot's PRs are exempt and get "Bug fixes and improvements."
  - The check reads the live description, so editing it and re-running the check is enough.
  - The release puts the text in the GitHub release notes and publishes it as the `release_notes.json` asset. Codemagic downloads that asset, falling back to the default text.
- **Replacing earlier submissions.** Codemagic expires the build still waiting for TestFlight beta review and cancels the previous App Store submission, so each release replaces the one before it.

## Acceptance + steps

- [x] T1 `changes` outputs `app` for app paths only, plus `version` on pushes. Proof: the filter and version logic run locally (macOS) and in `ubuntu:24.04` (mawk, GNU sort) against the real tag list and against made-up tags and pubspec versions.
- [x] T2 The `dmg` check fails an app-changing, non-Dependabot PR whose description has no text under `## What's New`. Proof: the extraction run on sample descriptions on both systems (CRLF, curly apostrophe, empty section, no section).
- [x] T3 The release job builds the Mac app with `--build-name=X.Y.Z` and publishes release `vX.Y.Z`, titled "Capture X.Y.Z". The release includes `Capture-X.Y.Z.dmg`, the appcast and `release_notes.json`, and its notes include the What's New text. Proof: actionlint, zizmor and diff review.
- [x] T4 Codemagic `ios-testflight` starts on `v*` tags and builds that version. It submits to TestFlight and App Store review and releases after approval. Proof: Codemagic CLI 0.69.0 (the version on the build machines) has `get-latest-build-number --all-versions`; the publishing keys come from Codemagic's App Store Connect publishing docs; the YAML parses.
- [x] T5 README and AGENTS.md (after the Hard Eng block, which updates preserve) describe the release flow and the required What's New section.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `feature/release-versioning` from `origin/main` (755d656). `python3 .hooks/hard-eng.py check --plan-stage Draft` → all gates PASS, exit 0.
Execution: One builder; release.yml, codemagic.yaml, README.md and AGENTS.md; then PR and merge.

## Risks + recovery

- If the webhook does not start Codemagic for a tag created with GITHUB_TOKEN, start `ios-testflight` by hand on the tag.
- The first release cancels the 1.0 review and resubmits build 5 for 1.0; the owner accepted this.
- Concurrent merges cannot pick the same version, because the release concurrency group runs them one at a time.
- A failed Mac release publishes no tag, so the next run reuses the version.

## ux_reference

N/A — release automation only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `feature/release-versioning`. `python3 .hooks/hard-eng.py check --plan-stage Complete` → all gates PASS, exit 0 (line coverage 76.54%), including actionlint and zizmor.
- Version on the real tags (only `-alpha` tags) with pubspec 1.0.0 → 1.0.0. With `v1.0.0` → 1.0.1. With `v1.0.9`, `v1.0.10` → 1.0.11. With `v1.0.5` and pubspec 1.1.0 → 1.1.0. With `v1.1.0` and pubspec 1.1.0 → 1.1.1. Same results on macOS and Ubuntu.
- What's New extraction: a CRLF description with "## What’s New" → exactly the section's two lines. An empty section → empty (the check fails). No section → empty.
E2E: Passed — local runs of the version and What's New logic on macOS and on the runner's Ubuntu userland. The tag → Codemagic path runs only on the real merge and is recorded under Delivery.

Delivery target: Merge
Delivery: Pending — PR, merge to `main`. The merge should publish Mac release v1.0.0 with `release_notes.json`, and its tag should start Codemagic `ios-testflight` building 1.0.0 (build 5). If Codemagic does not start, start it by hand on the tag.
