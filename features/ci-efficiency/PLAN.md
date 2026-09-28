# Capture CI and native agent migration

Status: Draft

## Outcome + scope

Make release verification a native workflow dependency and update the released Claude/Codex scaffold. Preserve app change detection, macOS compatibility builds, signing, notarization, Sparkle and iOS release policy. Product behavior and SDK choices remain unchanged.

## Repository context

Owners: `.github/workflows/release.yml`, `.github/workflows/hard-eng.yml`, `hard-eng.gates.json`, native agent settings and the supported updater.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous — the user authorized released-source migration, pnpm wherever supported, Claude/Codex-only tooling, one combined pull request per repository, review, checks and merge.

## Acceptance + steps

- [ ] Released scaffold at `d2085f745de39214aaaf6b34192378c9d1094a3d` → supported updater succeeds; repeat changes nothing; repository CLAUDE aliases and retired tooling are absent while unique guidance remains.
- [ ] The release job starts only after the hard-eng job succeeds, without polling on a macOS runner. → native gates and workflow checks pass with the original assertions.
- [ ] CI-only changes continue to build and publish no app; app-changing pull requests retain the DMG and public What's New checks. → existing native tests and configured checks pass.
- [ ] Actual verification and runner timing → retain measured commands/results; make no unsupported percentage claim.

## Baseline + execution

Result: Passed
Evidence: Starting `480c55c9ca3b7dcf07baec876848aabe6819f416` completed [native CI](https://github.com/sgaabdu4/capture/actions/runs/35868109827) successfully before migration; local updater candidate verification is pending the shared test slot.
Execution: One builder at existing owners, followed by diff review and the native candidate, Ready and shipping checks. Heavy suites run only in the coordinated slot.

## Risks + recovery

Preserve custom settings and instruction tails before retirement. Stop on a conflicting updater plan; recover a known migration change through Git without overwriting unrelated work. Retain existing publishing and product safety guards.

## ux_reference

N/A — agent configuration and CI only; no app interface or appearance changes.

## Verification

Result: Pending
Evidence: Native candidate and final verification have not run yet.
E2E: N/A — no product journey changes; supported updater behavior and actual hosted workflow results are the relevant proof.

Delivery target: Merge
Delivery: Pending — exact pull request checks, guarded merge and merged-main results remain required.
