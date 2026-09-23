import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/presentation/widgets/source_word.dart';
import 'package:flutter/material.dart';

/// The exact words an item came from. When [onSplit] is set, tapping a word
/// splits the item before it (at that word's transcript offset).
class SourceWords extends StatelessWidget {
  const SourceWords({required this.sources, required this.onSplit, super.key});

  final List<SourceSpan> sources;
  final ValueChanged<int>? onSplit;

  static final _word = RegExp(r'\S+');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onSplit = this.onSplit;
    return Container(
      width: .infinity,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        border: Border(
          left: .new(color: context.paper.pencil, width: Sizes.sourceRule),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: Spacing.xxs,
        children: [
          if (onSplit != null) Text(l10n.sourcesHint, style: context.textTheme.bodySmall),
          Wrap(
            children: [
              for (final SourceSpan(:start, :excerpt) in sources)
                for (final match in _word.allMatches(excerpt.value))
                  SourceWord(
                    text: excerpt.value.substring(match.start, match.end),
                    onTap: switch (onSplit) {
                      final ValueChanged<int> split when match.start > 0 => () => split(
                        start + match.start,
                      ),
                      _ => null,
                    },
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
