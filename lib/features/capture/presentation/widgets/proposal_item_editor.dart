import 'package:capture/core/domain/values/required_text.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/presentation/widgets/flag_chips.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_header.dart';
import 'package:capture/features/capture/presentation/widgets/source_words.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:flutter/material.dart';

/// Editor card for one proposal item. Owns the title/body text controllers
/// and keeps them in sync with [item].
class ProposalItemEditor extends StatefulWidget {
  const ProposalItemEditor({
    required this.item,
    required this.groups,
    required this.today,
    required this.editable,
    required this.onChanged,
    required this.onPickDate,
    required this.onPickTime,
    required this.onClearWhen,
    required this.onReminder,
    required this.onSplit,
    required this.onMergeNext,
    super.key,
  });

  final ProposalItem item;
  final List<Group> groups;

  /// Wall-clock now in the capture's time zone.
  final DateTime today;
  final bool editable;
  final ValueChanged<ProposalItem> onChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onClearWhen;
  final ValueChanged<bool> onReminder;

  /// Called with the transcript offset to split before.
  final ValueChanged<int> onSplit;

  /// Null for the last item.
  final VoidCallback? onMergeNext;

  @override
  State<ProposalItemEditor> createState() => _ProposalItemEditorState();
}

class _ProposalItemEditorState extends State<ProposalItemEditor> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  static const _included = 1.0;
  static const _bodyMaxLines = 6;
  static const _fade = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    final ProposalItem(:title, :body) = widget.item;
    _title.text = title ?? '';
    _body.text = body ?? '';
  }

  @override
  void didUpdateWidget(covariant ProposalItemEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ProposalItem(:title, :body) = widget.item;
    if (title != optionalText(_title.text)) _title.text = title ?? '';
    if (body != optionalText(_body.text)) _body.text = body ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ProposalItemEditor(:item, :editable, :onChanged, :onMergeNext) = widget;
    final ProposalItem(:included, :isTask, :due, :reminder, :flags, :sources) = item;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: AnimatedOpacity(
        duration: _fade,
        opacity: included ? _included : Opacities.excluded,
        child: PaperCard(
          child: Column(
            crossAxisAlignment: .start,
            spacing: Spacing.sm,
            children: [
              ProposalItemHeader(
                item: item,
                titleController: _title,
                groups: widget.groups,
                editable: editable,
                onChanged: onChanged,
              ),
              TextField(
                controller: _body,
                enabled: editable,
                minLines: 1,
                maxLines: _bodyMaxLines,
                style: context.textTheme.bodyMedium,
                decoration: .new(hintText: l10n.detailsHint),
                onChanged: (value) => onChanged(item.withBody(value)),
              ),
              if (isTask)
                WhenRow(
                  due: due ?? reminder,
                  hasReminder: reminder != null,
                  today: widget.today,
                  enabled: editable,
                  onPickDate: widget.onPickDate,
                  onPickTime: widget.onPickTime,
                  onClear: widget.onClearWhen,
                  onReminder: widget.onReminder,
                ),
              if (flags.isNotEmpty) FlagChips(flags: flags),
              SourceWords(sources: sources, onSplit: editable ? widget.onSplit : null),
              if (onMergeNext != null && editable)
                Align(
                  alignment: Alignment.centerRight,
                  child: LinkButton(l10n.mergeNext, icon: Icons.merge_type, onPressed: onMergeNext),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
