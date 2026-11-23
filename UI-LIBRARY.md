# UI library

One section for each library entry of `ui_library`; one row for each part. Written by `python3 .hooks/hard-eng.py ui-library --write`; the use lines are written by hand.

## `lib/core/widgets/**`

- `EmptyNote` — Truthful empty-state message inside cards and lists.
- `ExpandableCard` — Expandable paper card row shared by capture and group lists; the expand arrow shows unless a trailing widget replaces it.
- `IconAction` — Tooltipped icon button for inline, dialog, and toolbar actions, with a flush mode that draws the icon at the leading edge inside a full tap area.
- `IconBadge` — Circular icon badge used as a list-row leading visual.
- `InkButton` — Primary filled ink button with an optional busy spinner.
- `LineButton` — Secondary outlined button for neutral actions and pickers.
- `LinkButton` — Quiet text button with an optional trailing icon, a 48 point tap target, and a flush mode that lines its text up with the content above, and a destructive mode that colours the label with the error role.
- `PageFrame` — Scrollable page scaffold with an underlined title, subtitle, and actions.
- `PaperCard` — Paper-styled rounded container with border and soft shadow.
- `PaperCheckbox` — Theme-styled two-state checkbox for tasks, proposals, and settings, with a flush mode that draws the box at the leading edge inside a full tap area.
- `PaperDialog` — Paper-styled modal dialog with a handwritten title, body, and actions.
- `PaperDropdown` — Theme-styled single-select dropdown field.
- `PaperField` — Theme-styled text input with an optional label above it; obscured fields disable suggestions and autocorrect.
- `PaperSegmented` — Theme-styled single-choice segmented button control.
- `PaperSwitch` — Theme-styled toggle switch.
- `StatusDot` — Circular status indicator dot for connection and capture states.
- `TapSurface` — Shared Material InkWell surface for clickable rows, chips, and nav items.
- `Underlined` — Handwritten heading with the soft curved pencil underline.
