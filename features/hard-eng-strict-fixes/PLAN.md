# Hard Eng strict rules

Status: Draft

## Outcome + scope

The project passes Hard Eng's strict checks with no regression: no comment blocks, no skipped test, CRAP at most 30, no unused class member, flutter_skill_lints 0.14.0, a current freshness report. Non-goals: new features.

## Repository context

Owners: `lib/`, `test/`, `integration_test/`, `ios/`, `macos/`, `analysis_options.yaml`, `.dart-decimaterc.json`, `pubspec.yaml`.
Same cause: the old rules allowed doc comments and an env-gated skip; the new ones refuse both.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous. The owner asked for the strict-rules repair across all projects (2026-11-15). The PR stays open for the coordinator to merge.

## Acceptance + steps

- [ ] Every flagged comment block is removed, Swift files included.
- [ ] The live Notion journey is no longer skipped by an environment flag: it lives in `integration_test/`, which `flutter test` does not run.
- [ ] `.dart-decimaterc.json` holds `health.max_crap` 30 and every function is at or under it, by real tests or refactors.
- [ ] No unused class member.
- [ ] `flutter_skill_lints` is `^0.14.0`.
- [ ] Freshness and every other gate pass.

## Baseline + execution

Result: Pending
Evidence: pending

## Risks + recovery

A comment held a reason the code does not show: the reason is kept as one terse line.

## ux_reference

N/A — no visible change.

## Verification

Result: Pending
Evidence: pending
