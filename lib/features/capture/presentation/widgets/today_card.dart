import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/features/capture/presentation/widgets/home_card.dart';
import 'package:capture/features/capture/presentation/widgets/home_card_row.dart';
import 'package:flutter/material.dart';

/// One open task due today or earlier, as the Today card shows it.
typedef TodayItem = ({String title, String due, bool done});

/// Called with the tapped row's index and its new done state.
typedef TodayDoneChanged = void Function(int index, {required bool done});

/// Tasks due today or overdue, with a checkbox each.
class TodayCard extends StatelessWidget {
  const TodayCard({
    required this.items,
    required this.onDoneChanged,
    required this.onViewAll,
    super.key,
  });

  final List<TodayItem> items;
  final TodayDoneChanged onDoneChanged;
  final VoidCallback onViewAll;

  void _changed(int index, bool? value) {
    if (value case final bool done) onDoneChanged(index, done: done);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HomeCard(
      title: l10n.cardToday,
      onViewAll: onViewAll,
      children: [
        if (items.isEmpty) EmptyNote(l10n.emptyToday),
        for (final (index, (:title, :due, :done)) in items.indexed)
          HomeCardRow(
            leading: Checkbox(value: done, onChanged: (value) => _changed(index, value)),
            title: title,
            subtitle: due,
          ),
      ],
    );
  }
}
