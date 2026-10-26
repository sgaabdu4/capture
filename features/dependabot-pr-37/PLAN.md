# Dependabot update PR 37

Status: Complete

## Outcome + scope

Dependabot's weekly update ships: `flutter_local_notifications` 22.3.1 → 22.3.2 (no `PlatformException` on iOS 27 when permission is refused or a badge-only notification fires), `timezone` 0.11.1 → 0.11.2 (time zone database 2026e) and the `pnpm/setup` action v3.0.0 → v3.1.1 in the Release workflow. Out of scope: app code, other dependencies and the `Dependabot merge` workflow.

## Repository context

Owners: `pubspec.yaml` + `pubspec.lock` (the two Dart packages); `.github/workflows/release.yml` (`dmg` and `release` jobs, the two `pnpm/setup` steps); `lib/core/data/reminders/reminder_datasource.dart` (the only user of `flutter_local_notifications`); `lib/core/data/system/zone_offsets.dart` and the date resolver (users of `timezone`).
Same cause: Dependabot pull requests fail Hard Eng's plan check unless a changed plan records them → A29's hourly `Dependabot merge` workflow appended a line to the root `PLAN.md` for PRs 30, 32 and 34 (helped). For PR 37 it did nothing: its `DEPENDABOT_TOKEN` is refused (401), and the run still reports success. Appending to the root plan also no longer passes, because Hard Eng now checks a changed plan's newer fields, so this update has its own plan. The workflow is the only other place with this cause; it needs a new token and to record updates in their own plan, which is left to the owner.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Agent-loop in the owner's daily dependency task: fix a failing Dependabot pull request, merge it when the required checks pass and confirm the release; merging and the production release were approved by the owner for this task.

## Acceptance + steps

- [x] Reminders still go through the updated notifications plugin, and a native failure keeps the owed work → `test/features/capture/presentation/notifiers/capture_flow_notifier_test.dart::a native reminder failure keeps owed work and continues later captures` passes.
- [x] Dates still resolve in the capture's zone with the new time zone database, including daylight-saving gaps → `test/features/capture/domain/dates/date_resolver_test.dart::daylight-saving gap and overlap are flagged` passes.
- [x] The Release workflow still builds and packs the DMG with `pnpm/setup` v3.1.1 → N/A — no test runs a workflow step; the pull request's `dmg` check builds Capture.app with it, and actionlint and zizmor pass.

## Baseline + execution

Result: Passed
Evidence: Starting point `main` at 6a12609 passed the required `hard-eng` check in CI (Release run 40195320704). PR 37 failed `hard-eng` with "repository changes need an applicable PLAN.md".
Execution: Single builder; this plan on top of Dependabot's commit, rebased on `main`.

## Risks + recovery

A package update could change reminder or date behaviour on a real device. Recovery: revert the merge; Sparkle and TestFlight then pick up the next release.

## ux_reference

N/A — dependency versions only; no app screens change.

## Verification

Result: Passed
Evidence: `python3 .hooks/hard-eng.py check --base origin/main` on this branch, and the pull request's required `hard-eng` and `dmg` checks.
E2E: N/A — no user journey changes; the plugin and database updates are covered by the tests named under Acceptance.

Delivery target: Merge
Delivery: Pending — merge PR 37 to `main` once `hard-eng` and `dmg` pass; the merge publishes the next release.
