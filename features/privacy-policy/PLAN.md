# Privacy policy

Status: Complete

## Outcome + scope

`PRIVACY.md` states what Capture keeps on the device, what it sends to TypeSafe and Notion, and what it never collects. App Store Connect needs a public privacy policy URL, and this file provides it: https://github.com/sgaabdu4/capture/blob/main/PRIVACY.md. Out of scope: app code and the App Store listing text.

## Repository context

Owner: `PRIVACY.md` at the repository root (new). The facts come from the in-app privacy text (`privacyBody`, `phonePrivacyBody`, `phoneResetBody` and `resetBody` in `lib/l10n/app_en.arb`) and from the network endpoints in `lib/`: `api.typesafe.ai`, `api.notion.com` and the Hugging Face model downloads. There are no analytics SDKs.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the owner agreed to a PR that adds the privacy policy ("Ok") as part of the App Store release they asked for. Markdown only, so the Mac release workflow treats it as documentation and publishes nothing.

## Acceptance + steps

- [x] P1 `PRIVACY.md` matches the app's own behaviour. Audio and recordings stay on the device. Only transcript text and group descriptions go to TypeSafe. Items go to Notion only after approval or with auto-save. Keys stay in the Keychain. There are no analytics or tracking. Reset Capture removes the keys and local data. Proof: each statement checked against `lib/l10n/app_en.arb` and the endpoints in `lib/`.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `docs/privacy-policy`, branched from `origin/main` (ba82702), with no app code changed: `python3 .hooks/hard-eng.py check --plan-stage Draft --base 4b825dc642cb6eb9a060e54bf8d69288fbee4904` → 14/14 PASS, exit 0.
Execution: One builder; one Markdown file, then PR.

## Risks + recovery

- The policy could drift from the app. Recovery: update `PRIVACY.md` in the same PR as any change to what leaves the device.

## ux_reference

N/A — documentation only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `docs/privacy-policy`. Each statement was reviewed against the in-app privacy and reset strings and against the endpoint list (`grep -rhoE "https://..." lib ios/Runner`). `python3 .hooks/hard-eng.py check --plan-stage Complete` → 14/14 PASS, exit 0.
E2E: N/A — documentation only.

Delivery target: Merge
Delivery: Pending — merge to `main` after Hard Eng CI passes; then set the privacy policy URL in App Store Connect.
