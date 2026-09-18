# Capture macOS alpha

Status: Ready

## Outcome + scope

Working private Mac alpha: shortcut → record → local Parakeet transcript → code candidate boundaries + Jev decisions → editable proposal → approve → Notion (captures, audio, library, groups) → approved macOS reminders. Non-goals: brief §1 exclusions (accounts, backend, OAuth, other platforms, calendars, chat, search, summaries, recurring tasks, live captions, other models).

## Repository context

Owners: `lib/` (Dart app + logic), `macos/Runner/` (Swift overlay panel, hotkey, audio, notifications), `test/` (unit/widget/eval fixtures), `PRODUCT.md`, `DESIGN.md`. Starting point = empty `flutter create --platforms=macos --empty` scaffold (commit 9cb35cf) + Hard Eng scaffold (2c0980d).

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous — user brief §2 "proceed to implementation instead of stopping after the plan"; local commits on `feature/capture-alpha` only; no push, publish or unrelated Notion changes.

## Acceptance + steps

Each item names its proof. "Live" means an opt-in run with the owner's own keys and a dedicated test Notion page; mocks never count as live proof.

- [x] A1 Candidate boundaries cover every transcript character exactly once (UTF-16 half-open spans + exact excerpt). Proof: `test/features/capture/domain/text/candidate_splitter_test.dart`, `test/eval/candidate_coverage_test.dart` (100% gold boundaries are candidates).
- [x] A2 Jev boundary pass (one Noul per unit) + late-correction Noul; code assembles thoughts; no text is rewritten or lost. Proof: `test/features/capture/repositories/capture_analysis_repository_test.dart`; eval source-loss 0.
- [x] A3 Jev classification pass (group Choice, task/alert/recall Nouls, day/time Choices over code-found candidates) → code-built proposal with review flags; dates resolved in the capture's IANA zone incl. DST gap/overlap. Proof: `test/features/capture/domain/dates/date_resolver_test.dart`, `test/features/capture/domain/proposal/proposal_builder_test.dart`.
- [x] A4 Jev client: pinned `jev-1.13.0`, bounded retries honouring Retry-After, typed failures, no content logged. Proof: `test/features/capture/data/services/jev_http_service_test.dart`, `test/features/capture/data/datasources/jev_remote_datasource_test.dart`.
- [x] A5 Labelled eval (19 synthetic cases) replays 29 recorded live `jev-1.13.0` responses. Proof: `flutter test test/eval/jev_eval_test.dart` (replay; fails on unrecorded requests or source loss). 4 labels were widened after review (pronoun-continuations, bike→Ideas, poorly-punctuated→Ideas, call-mum→chooseTime); known miss: over-split of "He suggested I try Zig" (boundary 0.79).
- [ ] A6 Global shortcut (default Ctrl+Option+R, configurable) starts/stops recording from any app without Accessibility permission; a key held down does not toggle repeatedly. Proof: native hotkey unit + manual run from another app.
- [ ] A7 Recording writes PCM16 16 kHz mono to disk while recording (durable before stop), shows the charcoal pill with live waveform and timer, hard-stops at 5:00, and discards nothing on crash (draft recovered at launch). Proof: recorder tests + manual run.
- [ ] A8 Local Parakeet-TDT-0.6B-v3 int8 via sherpa_onnx in a background isolate; model downloaded on first run with progress, resume and SHA-256 check into Application Support; CC-BY-4.0 attribution shown. Proof: model-store tests (hash/resume) + manual transcription of a real recording.
- [ ] A9 Review card ("Ready to save?", count line, items, No / Yes, save / Edit) near the pill; Edit opens the focused editor (title/body/group/type/due/reminder, split/merge, include/exclude); approval blocked while `approvalProblems` is non-empty. Proof: widget tests + screenshots vs references.
- [ ] A10 Settings/onboarding: TypeSafe key and Notion token stored only in Keychain (legacy keychain), validated with `GET /v1/models` and `GET /v1/users/me`; Notion parent page chosen by URL/ID and access checked. Proof: settings tests with fake store + live validation.
- [ ] A11 Notion schema setup under the parent (Capture area page, Groups/Captures/Library data sources, marker) is idempotent; Groups editor edits the Groups data source. Proof: schema tests against recorded shapes + live setup on the test page.
- [ ] A12 Approved save: capture page → items → audio upload (M4A, within the workspace upload limit) → mark Saved; per-step progress persisted in SQLite; retry resumes after the last confirmed step and never duplicates (lookup by stable IDs before re-creating). Proof: save-sequence tests with injected failures + live save.
- [ ] A13 Reminders are scheduled only for approved, persisted tasks with a reminder (UNUserNotificationCenter); none before approval. Proof: scheduler tests + manual notification.
- [ ] A14 Main window (Home, Groups, Recordings, To-do, Upcoming) and menu-bar popover (Record, Open app, Settings, Quit) match the approved references with the documented deviations, with truthful empty/error states. Proof: rendered screenshots in `docs/design/` + review.
- [ ] A15 README documents setup, keys, model licence, privacy and limits. Proof: file.
- [ ] A16 Full E2E: shortcut in another app → speak → review → approve → Notion rows + audio + reminder. Proof: manual live run recorded under Verification.

Documented deviations from the mockups: shortcut shown as the configured combo (default ⌃⌥R, not ⌘R, which apps already use); no Weekly summary; no nav item selected on Home; no active mic/waveform while reviewing; count line on the review card; truthful empty states instead of sample data.

## Baseline + execution

Result: Passed
Evidence: `python3 .hooks/hard-eng.py check --plan-stage Draft` on `feature/capture-alpha` at b263efb: all 12 checks PASS (lockfile, vulnerabilities, format, security, types-lint, import-boundaries, tests, dead-code-duplicates, performance, secrets-files, secrets-history, strict-types-lint). Main baseline repair: `features/gate-adaptation/PLAN.md`.
Execution: Single builder; slices per brief §18.

## Risks + recovery

- Jev thresholds are provisional (`lib/domain/jev/thresholds.dart`); uncertain bands raise review flags rather than guessing. Recovery: tune on the eval set only with new labelled cases.
- 1.4 GB model memory: recogniser loaded lazily in an isolate and released after idle. Recovery: fall back to a clear error, audio kept.
- Notion free-plan limits (5 MiB uploads, 1000 blocks): read limits from `/v1/users/me`, encode ≤64 kbps AAC, show a clear error on block limit; capture stays local and retryable.
- Partial saves: every Notion step is persisted before the next; retries query by Capture ID / Item ID first.

## ux_reference

Result: Passed
Evidence: The owner supplied four approved Capture reference images in the build conversation. They are stored in `docs/design/reference/` (`main-window.png`, `menu-popover.png`, `recording-pill.png`, `review-card.png`) and were inspected as the visual target. The direction is settled; the only changes are the documented deviations under Acceptance. Rendered-vs-reference proof of the built UI remains acceptance item A14.
Surface: New — macOS main window (`lib/features/*/presentation`, shell `lib/features/shell`), native overlay and menu (`macos/Runner/Native`), tokens in `lib/core/theme`
Before: N/A — new app; the starting point was an empty `flutter create` scaffold with no prior UI
Proposed: ![Approved main window](docs/design/reference/main-window.png)
Capture: Owner-provided reference images (PNG), checked into `docs/design/reference/`; opened and compared during theme and widget work.
Review: Covers Home, Groups, Recordings, To-do, Upcoming, Settings, the editor, the review card, the pill and the menu. Deviations: the ⌃⌥R shortcut label, no Weekly summary, no selected nav item on Home, no active waveform while reviewing, a count line on the review card, and truthful empty states.

## Verification

Result: Pending
Evidence: Pending
E2E: Required — shortcut from another app → speak → review → approve → Notion + reminder.
