# Domain value objects

Status: Complete

## Outcome + scope

Hard Eng `732b31c` installs and its gates pass. That revision pins `flutter_skill_lints ^0.12.0`, whose value-object rules find 25 raw required `String` or unit-named fields on domain entities. Required domain text becomes a validated value object; text that can legitimately be blank becomes `String?`. Stored drafts and the Notion mirror keep their primitive JSON, so nothing on disk changes. Out of scope: other domain refactors and behaviour changes beyond skipping unusable Notion rows (below).

## Repository context

Owners: the 12 flagged entities under `lib/core/domain/entities`, `lib/features/{capture,groups,library}/domain`; new value objects in `lib/core/domain/values` and `lib/features/{capture,groups}/domain/values`; their mappers in `data/models`; Notion readers in `groups_remote_datasource.dart` and `library_remote_datasource.dart`; callers and tests the compiler lists. The data models keep primitives (SQLite JSON), per value-objects.md Option B.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the Hard Eng updater refused `732b31c` on these findings, blocking the owner's "merge all" (PR #23). The owner replied "fix it then instead of stopping, hard eng gave us good feedback so fix the issue". The merge publishes one Mac release, which the owner's merge approval covers.

Value objects (Freezed, private raw redirect, public factory that checks the value, `value` getter, `toString` = value). The check is an assert, as the project's `avoid_throw` rule and the Flutter skill's value-object tests require; the text is otherwise kept exactly:
- `NotionId`: workspace parent, area and three data sources; `Group.id`; `LibraryEntry.pageId`; group references compared with them.
- `ByteSize`: `NotionWorkspace.maxUploadBytes` → `maxUpload`; rejects negative.
- `CaptureId`: `CaptureRecord.id`. `ItemId`: `ProposalItem.id`, `LibraryEntry.itemId` (the same value, written to Notion's Item ID).
- `TimeZoneId`: `CaptureRecord.timeZone`. `AudioPath`: `CaptureRecord.audioPath`.
- `JevModel`: `JevCallMetrics.model`, `JevResult.model`. `JevState`: `ClassificationPlan.state`.
- `GroupName`: `Group.name`, `ThoughtDecision.groupOption` (options are group names).
- `PassageId`: `Thought.id`, `TranscriptUnit.id` (code-generated `U001`/`T1` labels named to Jev; the `T` prefix now has one owner, `thoughtId`).
- `Excerpt`: `SourceSpan.excerpt`. Spans are never empty: blank transcripts stop before analysis, units and splits skip empty ranges.

Optional text (`String?`, blank normalised to null at the boundary): `ProposalItem.title` and `body` (the editor can clear them; "Add a title" still blocks approval), `Group.description`, `LibraryEntry.title` (Notion allows empty).

Notion rows missing a required field are skipped where the repositories turn models into entities (covering Notion reads and caches written by older versions): a Groups row with no name, and a Library page with no Item ID (pages made directly in Notion; today they all share one local row keyed by the blank ID).

Rejected: fake `HiveField` markers (no Hive here), renaming to dodge the unit rule, moving types out of `/domain/`.

## Acceptance + steps

- [x] T1 `dart analyze --fatal-infos` reports no issues with `flutter_skill_lints ^0.12.0` → 25 findings before, 0 after.
- [x] T2 Each value object rejects blank (and `ByteSize` negative) input → `test/core/domain/values/value_objects_test.dart`.
- [x] T3 Stored drafts, groups, library entries and the workspace round-trip through their models unchanged → existing mapper/repository tests pass.
- [x] T4 A Notion Groups row with no name and a Library page with no Item ID are skipped, not thrown → `groups_repository_test.dart`, `library_repository_test.dart`.
- [x] T5 The Hard Eng updater installs `732b31c` and its full gate passes → updater exits 0; `check --plan-stage Complete` exits 0.

## Baseline + execution

Result: Passed
Evidence: Current baseline after repair: the updater, run on `abc96b2`, verified and installed `732b31c` (commit `bad49a4`, exit 0). Original failed baseline (preserved): 2026-09-23, Hard Eng updater on `6bb5608` (main after PR #22) → `FAIL types-lint (exit 3)`: 24 `domain_raw_required_string` and 1 `domain_unit_primitive` across the 12 entities above; every other gate passed (import-boundaries, tests 76.26% coverage, dead-code-duplicates, performance, strict-types-lint, secrets, actionlint, zizmor). Reproduced on branch `fix/domain-value-objects` with the pin bumped: `dart analyze --fatal-infos` → the same 25.
Execution: One builder. Add value objects, change entities, regenerate Freezed, follow the compiler through mappers and callers, update tests, then run the updater and commit its changes with the code.

## Risks + recovery

- A value object's assert fires on data that was valid before (debug builds only; release keeps the value). Recovery: Notion input is filtered in the repositories; locally built values come from code that already rejects blanks; tests cover the mappers.
- Library pages made directly in Notion stop appearing in To-Do/Upcoming. Recovery: they never had a stable local row; restore by reading them by page id in a later change if wanted.

## ux_reference

N/A — no screen changes.

## Verification

Result: Passed
Evidence: 2026-09-23 on `fix/domain-value-objects`.
- `dart analyze --fatal-infos` (whole project, new lints) → No issues found. The new release's stricter rules also flagged `avoid_throw`, `prefer_dot_shorthands`, a nullable interpolation in `mergeItems`, a `?? ''` sort fallback and id-prefix literals in the new code; all fixed.
- `flutter test` → 150 passed, 2 skipped (137 before, plus 11 value-object cases and 2 skip cases).
- Skip proof: with the two repository filters removed (not committed), both skip tests fail with "GroupName must not be blank" / "ItemId must not be blank"; restored, they pass.
- Silent-conversion review: value objects placed in JSON maps, string interpolation or widget keys compile without error, so every such site was checked. Notion request bodies, Jev prompts and keys now use `.value`; widget keys stay `ValueKey<String>` for Marionette and tests.
- Gates: `python3 .hooks/hard-eng.py check --plan-stage Complete` → 14/14 PASS, exit 0 (Line coverage: 3821/5003 (76.37%; minimum 70%)).
E2E: Passed — the app-level widget tests (`capture_app_test.dart`, `responsive_layout_test.dart`) run the real app with fakes and pass. Not run against the owner's real local data on a device; the mappers keep the stored JSON shape, and blank Notion rows are filtered.

Delivery target: Merge
Delivery: Pending — PR, merge to `main`, main CI green; then PR #23 takes the new Hard Eng from `main`.
