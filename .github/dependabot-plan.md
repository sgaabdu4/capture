# Dependabot update PR @PR@

Status: Complete

## Outcome + scope

Dependabot's update ships: @TITLE@ (@URL@). Out of scope: app code and every dependency the pull request does not change.

## Repository context

Owners: the manifests, lock files and workflow files that the pull request changes.
Same cause: Dependabot pull requests fail Hard Eng's plan check unless a changed plan records them → the hourly `Dependabot merge` workflow writes this plan for each update (helped).

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: The owner's `Dependabot merge` workflow, recorded @DATE@: Dependabot updates merge themselves once the required `hard-eng` and `dmg` checks pass.

## Acceptance + steps

- [x] The app still builds, tests and packs with the updated versions → N/A — the required `hard-eng` check runs the full test suite and the `dmg` check builds Capture.app on this branch.

## Baseline + execution

Result: Passed
Evidence: `main` passed the required checks before this update; the pull request runs them again with the update.
Execution: Dependabot's commits plus this plan, written by the `Dependabot merge` workflow.

## Risks + recovery

An update could change app behaviour that no test covers. Recovery: revert the merge; Sparkle and TestFlight then pick up the next release.

## ux_reference

N/A — dependency versions only; no app screens change.

## Verification

Result: Passed
Evidence: The pull request's required `hard-eng` and `dmg` checks.
E2E: N/A — no user journey changes; the full test suite runs in the `hard-eng` check.

Delivery target: Merge
Delivery: Pending — auto-merge to `main` once `hard-eng` and `dmg` pass; the merge publishes the next release.
