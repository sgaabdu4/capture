import 'dart:async';

import 'package:capture/app/app_model.dart';
import 'package:capture/app/capture_flow.dart';
import 'package:capture/features/capture/domain/entities/capture.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/core/extensions/date_format.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/features/capture/domain/proposal/edits.dart';
import 'package:capture/ui/theme.dart';
import 'package:capture/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

/// Focused editor for one proposal. Edits are stored locally as you go;
/// nothing reaches Notion until "Save to Notion".
class EditorPage extends StatelessWidget {
  const EditorPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: model.editing,
    builder: (context, id, _) => ListenableBuilder(
      listenable: model.flow,
      builder: (context, _) {
        final r = id == null ? null : model.env.store.capture(id);
        if (r == null) {
          return const PageFrame(title: 'Review', children: [EmptyNote('Nothing to review.')]);
        }
        return _Editor(model: model, record: r);
      },
    ),
  );
}

class _Editor extends StatelessWidget {
  const _Editor({required this.model, required this.record});
  final AppModel model;
  final CaptureRecord record;

  bool get _editable => record.stage == CaptureStage.proposed;

  void _update(List<ProposalItem> items) => model.flow.updateItems(record.id, items);

  void _replace(ProposalItem item) =>
      _update([for (final i in record.items) i.id == item.id ? item : i]);

  @override
  Widget build(BuildContext context) {
    final problems = approvalProblems(record.items);
    final items = record.items;
    return Column(
      children: [
        Expanded(
          child: PageFrame(
            title: 'Ready to save?',
            subtitle: [
              if (record.includedItems.isNotEmpty) proposalSummary(record.includedItems),
              ?record.error,
            ].join(' · '),
            children: [
              for (final (index, item) in items.indexed)
                _ItemEditor(
                  key: ValueKey(item.id),
                  model: model,
                  record: record,
                  item: item,
                  editable: _editable,
                  onChanged: _replace,
                  onSplit: (at) => _split(item, at),
                  onMergeNext: index + 1 < items.length ? () => _merge(index) : null,
                ),
              const SizedBox(height: 12),
              _Transcript(text: record.transcript ?? ''),
            ],
          ),
        ),
        _BottomBar(model: model, record: record, problems: problems),
      ],
    );
  }

  void _split(ProposalItem item, int at) {
    final pieces = splitItem(item, record.transcript ?? '', at, model.env.newId());
    if (pieces == null) return;
    _update([
      for (final i in record.items)
        if (i.id == item.id) ...[pieces.$1, pieces.$2] else i,
    ]);
  }

  void _merge(int index) {
    final items = [...record.items];
    final merged = mergeItems(items[index], items[index + 1]);
    items
      ..[index] = merged
      ..removeAt(index + 1);
    _update(items);
  }
}

class _ItemEditor extends StatefulWidget {
  const _ItemEditor({
    required this.model,
    required this.record,
    required this.item,
    required this.editable,
    required this.onChanged,
    required this.onSplit,
    required this.onMergeNext,
    super.key,
  });

  final AppModel model;
  final CaptureRecord record;
  final ProposalItem item;
  final bool editable;
  final ValueChanged<ProposalItem> onChanged;
  final ValueChanged<int> onSplit;
  final VoidCallback? onMergeNext;

  @override
  State<_ItemEditor> createState() => _ItemEditorState();
}

class _ItemEditorState extends State<_ItemEditor> {
  late final _title = TextEditingController(text: widget.item.title);
  late final _body = TextEditingController(text: widget.item.body);

  @override
  void didUpdateWidget(covariant _ItemEditor old) {
    super.didUpdateWidget(old);
    if (widget.item.title != _title.text) _title.text = widget.item.title;
    if (widget.item.body != _body.text) _body.text = widget.item.body;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  ProposalItem get item => widget.item;
  tz.Location get _location => tz.getLocation(widget.record.timeZone);

  Set<ReviewFlag> _checks(DueDate date) =>
      checkInstant(date, _location, widget.model.env.now().toUtc());

  Future<void> _pickDate() async {
    final base = item.due ?? item.reminder;
    final now = tz.TZDateTime.now(_location);
    final picked = await showDatePicker(
      context: context,
      initialDate: base == null ? now : DateTime(base.year, base.month, base.day),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    final date = DueDate(
      picked.year,
      picked.month,
      picked.day,
      hour: base?.hour,
      minute: base?.minute,
    );
    _setWhen(date);
  }

  Future<void> _pickTime() async {
    final base = item.due ?? item.reminder;
    if (base == null) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: base.hour ?? 9, minute: base.minute ?? 0),
    );
    if (picked == null) return;
    _setWhen(base.withTime(picked.hour, picked.minute));
  }

  void _setWhen(DueDate date) {
    var next = setDue(item, date, flags: _checks(date));
    if (item.reminder != null && date.hasTime) {
      next = setReminder(next, date, flags: _checks(date));
    }
    widget.onChanged(next);
  }

  void _toggleReminder(bool on) {
    final due = item.due;
    if (on && (due == null || !due.hasTime)) return;
    widget.onChanged(setReminder(item, on ? due : null, flags: on ? _checks(due!) : const {}));
  }

  @override
  Widget build(BuildContext context) {
    final groups = widget.model.settings.activeGroups;
    final enabled = widget.editable;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Opacity(
        opacity: item.included ? 1 : 0.55,
        child: PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: item.included,
                    onChanged: enabled
                        ? (v) => widget.onChanged(setIncluded(item, v ?? false))
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _title,
                      enabled: enabled,
                      style: Styles.cardTitle,
                      decoration: const InputDecoration(hintText: 'Title'),
                      onChanged: (v) => widget.onChanged(setTitle(item, v)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _KindToggle(
                    kind: item.kind,
                    onChanged: enabled ? (k) => widget.onChanged(setKind(item, k)) : null,
                  ),
                  const SizedBox(width: 12),
                  _GroupMenu(
                    groups: groups,
                    value: item.groupId,
                    onChanged: enabled ? (g) => widget.onChanged(setGroup(item, g)) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _body,
                enabled: enabled,
                minLines: 1,
                maxLines: 6,
                style: Styles.body,
                decoration: const InputDecoration(hintText: 'Details'),
                onChanged: (v) => widget.onChanged(setBody(item, v)),
              ),
              if (item.kind == ItemKind.task) ...[
                const SizedBox(height: 12),
                _WhenRow(
                  item: item,
                  today: tz.TZDateTime.now(_location),
                  enabled: enabled,
                  onPickDate: _pickDate,
                  onPickTime: _pickTime,
                  onClear: () => widget.onChanged(setReminder(setDue(item, null), null)),
                  onReminder: _toggleReminder,
                ),
              ],
              if (item.flags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in item.flags)
                      Chip(
                        label: Text(f.label, style: Styles.small.copyWith(color: Palette.ink)),
                        backgroundColor: const Color(0xFFF6EBD7),
                        side: BorderSide.none,
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              _Sources(
                item: item,
                transcript: widget.record.transcript ?? '',
                onSplit: enabled ? widget.onSplit : null,
              ),
              if (enabled && widget.onMergeNext != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: LinkButton(
                    'Merge with next',
                    icon: Icons.merge_type,
                    onPressed: widget.onMergeNext,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindToggle extends StatelessWidget {
  const _KindToggle({required this.kind, required this.onChanged});
  final ItemKind kind;
  final ValueChanged<ItemKind>? onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<ItemKind>(
    segments: const [
      ButtonSegment(value: ItemKind.note, label: Text('Note')),
      ButtonSegment(value: ItemKind.task, label: Text('Task')),
    ],
    selected: {kind},
    showSelectedIcon: false,
    onSelectionChanged: onChanged == null ? null : (s) => onChanged!(s.first),
    style: SegmentedButton.styleFrom(
      selectedBackgroundColor: Palette.ink,
      selectedForegroundColor: Palette.cream,
      foregroundColor: Palette.ink,
      side: const BorderSide(color: Palette.line),
      textStyle: const TextStyle(fontFamily: Fonts.hand, fontSize: 16),
    ),
  );
}

class _GroupMenu extends StatelessWidget {
  const _GroupMenu({required this.groups, required this.value, required this.onChanged});
  final List<Group> groups;
  final String? value;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 170,
    child: DropdownButtonFormField<String>(
      initialValue: groups.any((g) => g.id == value) ? value : null,
      hint: const Text('Group', style: Styles.label),
      isExpanded: true,
      style: Styles.body,
      items: [
        for (final g in groups)
          DropdownMenuItem(
            value: g.id,
            child: Text(g.name, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged == null ? null : (v) => v == null ? null : onChanged!(v),
    ),
  );
}

class _WhenRow extends StatelessWidget {
  const _WhenRow({
    required this.item,
    required this.today,
    required this.enabled,
    required this.onPickDate,
    required this.onPickTime,
    required this.onClear,
    required this.onReminder,
  });

  final ProposalItem item;
  final DateTime today;
  final bool enabled;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onClear;
  final ValueChanged<bool> onReminder;

  @override
  Widget build(BuildContext context) {
    final due = item.due ?? item.reminder;
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, size: 20),
        const SizedBox(width: 10),
        LineButton(
          due == null ? 'Add date' : formatDue(due.dateOnly, today),
          onPressed: enabled ? onPickDate : null,
        ),
        const SizedBox(width: 8),
        if (due != null)
          LineButton(
            due.hasTime ? formatTime(due.hour!, due.minute ?? 0) : 'Add time',
            onPressed: enabled ? onPickTime : null,
          ),
        if (due != null) ...[
          const SizedBox(width: 16),
          Switch(
            value: item.reminder != null,
            activeThumbColor: Palette.cream,
            activeTrackColor: Palette.ink,
            onChanged: enabled && due.hasTime ? onReminder : null,
          ),
          const SizedBox(width: 6),
          Text(due.hasTime ? 'Remind me' : 'Add a time to set a reminder', style: Styles.label),
          const Spacer(),
          if (enabled)
            IconButton(
              tooltip: 'Remove date',
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClear,
            ),
        ],
      ],
    );
  }
}

/// The exact words this item came from. Tapping a word (when editable)
/// splits the item before it.
class _Sources extends StatelessWidget {
  const _Sources({required this.item, required this.transcript, required this.onSplit});
  final ProposalItem item;
  final String transcript;
  final ValueChanged<int>? onSplit;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
    decoration: const BoxDecoration(
      border: Border(left: BorderSide(color: Palette.ray, width: 3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onSplit != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('What you said · tap a word to split before it', style: Styles.small),
          ),
        Wrap(
          children: [
            for (final s in item.sources)
              for (final m in RegExp(r'\S+').allMatches(s.excerpt))
                _Word(
                  text: m[0]!,
                  onTap: onSplit == null || m.start == 0 ? null : () => onSplit!(s.start + m.start),
                ),
          ],
        ),
      ],
    ),
  );
}

class _Word extends StatelessWidget {
  const _Word({required this.text, required this.onTap});
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final word = Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(text, style: Styles.label.copyWith(fontStyle: FontStyle.italic)),
    );
    if (onTap == null) return word;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: word),
    );
  }
}

class _Transcript extends StatelessWidget {
  const _Transcript({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: const Text('Full transcript', style: Styles.label),
      expandedAlignment: Alignment.centerLeft,
      children: [Text(text.isEmpty ? 'No words were heard.' : text, style: Styles.body)],
    ),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.model, required this.record, required this.problems});
  final AppModel model;
  final CaptureRecord record;
  final List<String> problems;

  @override
  Widget build(BuildContext context) {
    final flow = model.flow;
    final saving = flow.phase == Phase.saving && flow.activeId == record.id;
    final canSave =
        (record.stage == CaptureStage.proposed || record.stage == CaptureStage.approved) &&
        record.includedItems.isNotEmpty &&
        problems.isEmpty &&
        (flow.phase == Phase.idle || flow.phase == Phase.review);
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 20),
      decoration: const BoxDecoration(
        color: Palette.sidebar,
        border: Border(top: BorderSide(color: Palette.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              problems.isNotEmpty
                  ? problems.join(' · ')
                  : record.stage == CaptureStage.saved
                  ? 'Saved to Notion.'
                  : 'Nothing is sent to Notion until you save.',
              style: Styles.label.copyWith(color: problems.isEmpty ? Palette.muted : Palette.error),
            ),
          ),
          if (record.stage == CaptureStage.proposed)
            LineButton(
              "Don't save",
              onPressed: () {
                unawaited(flow.dismiss(record.id));
                model.section.value = Section.recordings;
              },
            ),
          const SizedBox(width: 12),
          InkButton(
            record.stage == CaptureStage.approved ? 'Retry save' : 'Save to Notion',
            busy: saving,
            onPressed: canSave ? () => _save(context) : null,
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    await model.flow.approve(record.id);
    final r = model.env.store.capture(record.id);
    if (!context.mounted) return;
    if (r?.stage == CaptureStage.saved) {
      showNotice(context, 'Saved to Notion.');
      model.section.value = Section.recordings;
    } else if (r?.error != null) {
      showNotice(context, r!.error!);
    }
  }
}
