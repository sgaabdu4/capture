# Hard Eng 1c855849 update

Status: Complete

## Outcome + scope

The repo runs Hard Eng `1c855849` installed by the supported setup script, with every repository check passing and the Hard Eng CI job set up for Bun. Out of scope: app code, the release build jobs, dependency updates.

## Repository context

Owners: `.hooks/hard-eng-source.json` and the setup commit (installed revision); `.hooks/`, `.agents/skills/` and the Hard Eng block of `AGENTS.md` (scaffold); `.github/workflows/release.yml` `hard-eng` job (CI bootstrap). The release gates run Hard Eng tools through Bun, and setup printed that this job did not set Bun up.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Agent-loop under the owner's Hard Eng update request: update to `1c855849`, fix what the update reports at its owner, merge when CI is green.

## Acceptance + steps

- [x] Installed revision is `1c855849` → `.hooks/hard-eng-source.json` shows `1c855849c99b3c3dc3a4fa3fab1f20d0ce0b3911` after the setup script committed the update.
- [x] The `hard-eng` CI job sets up Bun before it runs the check → `oven-sh/setup-bun` replaces the pnpm bootstrap, and `actionlint` and `zizmor` pass.
- [x] Repository checks pass on the updated scaffold → `python3 .hooks/hard-eng.py check` exits 0.

## Baseline + execution

Result: Passed
Evidence: Starting revision `0dbb984` (Hard Eng `02f02959`). `python3 .hooks/hard-eng.py update` printed nothing and left the revision unchanged; the setup script then installed `1c855849`. The first full check on the new scaffold passed all 12 checks (line coverage 78.84%). Setup printed one pending CI adaptation, fixed in the workflow.
Execution: Single builder; scaffold update plus one workflow edit.

## Risks + recovery

The `hard-eng` job could fail on GitHub if the Bun bootstrap differs from the template; the pull request checks run that job before merge. Recovery = revert the PR.

## ux_reference

N/A — tooling only; no app screens change.

## Verification

Result: Passed
Evidence: Full `python3 .hooks/hard-eng.py check` without a base passed on `1c855849` before the workflow edit; rerun after it, see the pull request.
E2E: N/A — no user journey changes; scaffold update verified by the native checks.

Delivery target: Merge
Delivery: Pending — PR merged into main with the required `hard-eng` check passing on the merged revision; no app files change, so no release runs.
