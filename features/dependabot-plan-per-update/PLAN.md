# Dependabot updates get their own plan

Status: Complete

## Outcome + scope

The hourly `Dependabot merge` workflow writes `features/dependabot-pr-<number>/PLAN.md` from `.github/dependabot-plan.md` for each open Dependabot pull request, instead of adding a line to the root `PLAN.md`. Out of scope: the root plan, the token and the merge step.

## Repository context

Owners: `.github/workflows/dependabot-merge.yml` (the record and merge loop); `.github/dependabot-plan.md` (the plan text it fills in).
Same cause: Dependabot pull requests fail Hard Eng's plan check unless a changed plan records them → `features/dependabot-pr-37/PLAN.md` fixed PR 37 by hand (helped); this change makes the workflow do the same for every update.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: The owner asked for this change on 2026-10-26, after renewing `DEPENDABOT_TOKEN`.

## Acceptance + steps

- [x] A Dependabot change with the written plan passes Hard Eng's plan check, and the same change without it fails → N/A — no test runs a workflow step; the plan writer from the workflow was run on a copy of `main` with a sample title that has quotes, `&` and `/`, and `validate_plans` returned Complete with the plan and refused the change without it.
- [x] The workflow still parses and passes the workflow checks → N/A — actionlint and zizmor run in the `hard-eng` check.

## Baseline + execution

Result: Passed
Evidence: `main` at cb5f0b98 passed the required `hard-eng` check (PR 37). Before this change, the root `PLAN.md` line failed Hard Eng's newer plan fields.
Execution: Single builder.

## Risks + recovery

A future Hard Eng plan rule could reject the written plan, and Dependabot pull requests would fail `hard-eng` again. Recovery: update `.github/dependabot-plan.md` to the new rule.

## ux_reference

N/A — CI workflow only; no app screens change.

## Verification

Result: Passed
Evidence: The plan writer run on a copy of `main`, `python3 .hooks/hard-eng.py check --base origin/main`, and the pull request's required `hard-eng` check.
E2E: N/A — no user journey changes.

Delivery target: Merge
Delivery: Pending — merge to `main` once `hard-eng` and `dmg` pass.
