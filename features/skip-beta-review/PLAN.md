# Skip beta review

Status: Complete

## Outcome + scope

Each iPhone release goes to App Store review without first being submitted to TestFlight beta review. A beta review that is still waiting can no longer block it. Builds still reach TestFlight's internal testers, which needs no review. Out of scope: the version, tag and What's New flow (`features/release-versioning`) and app code.

## Repository context

- Owner: `codemagic.yaml` `ios-testflight` publishing.
- Codemagic build 5 (1.0.0, from tag v1.0.0, 2026-09-23) uploaded, but its post-processing failed. Apple answered `POST /v1/betaAppReviewSubmissions` with 422: "Another build in the same train is already in beta review."
- Build 4 was still waiting for beta review, and the failure stopped the App Store submission. Beta review only serves external testers, and the app has no external tester group.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop.
- On 2026-09-23, asked how releases should handle TestFlight after that failure, the owner chose "Skip beta review (Recommended)".
- Merging releases v1.0.1 on both platforms. The owner accepted new versions replacing the 1.0 review ("I don't mind a new version out").

Decisions:
- Remove `submit_to_testflight: true`. `submit_to_app_store`, `cancel_previous_submissions` and `release_type: AFTER_APPROVAL` stay.
- Build 5 is left as it is. It has the same app code as build 4, which is still in 1.0 review.

## Acceptance + steps

- [x] T1 `ios-testflight` publishing no longer submits to beta review; App Store submission and auto-release are unchanged. Proof: diff review; the YAML parses; the Hard Eng gates pass.
- [x] T2 README and the workflow comment say builds go to TestFlight for internal testing, not beta review.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `fix/skip-beta-review` from `origin/main` (657b237), which passed the full Hard Eng check on the `release-versioning` branch and in main CI.
Execution: One builder; `codemagic.yaml` and `README.md`; then PR and merge.

## Risks + recovery

- App Store submission itself may fail on the next release. Recovery: read the post-processing message on the Codemagic build page, then fix or submit by hand.

## ux_reference

N/A — release configuration only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `fix/skip-beta-review`. `python3 .hooks/hard-eng.py check --plan-stage Complete` → all gates PASS, exit 0. `codemagic.yaml` parses, and publishing has no `submit_to_testflight`.
E2E: Passed — only the configuration changes. The new setup is exercised by the v1.0.1 release this merge starts, recorded under Delivery.

Delivery target: Merge
Delivery: Pending — PR, then merge to `main`. Expected: Mac release v1.0.1 and Codemagic started by the v1.0.1 tag through the new webhook. That build should upload and submit to App Store review with no beta-review step.
