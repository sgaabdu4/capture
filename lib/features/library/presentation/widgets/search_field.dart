import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:flutter/material.dart';

/// Search box over saved titles; starts from [query] and reports each edit.
class SearchField extends StatefulWidget {
  const SearchField({required this.query, required this.onChanged, super.key});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: const ValueKey(AppWidgetKeys.searchField),
      controller: _controller,
      onChanged: widget.onChanged,
      style: context.textTheme.bodyMedium,
      decoration: .new(
        hintText: l10n.searchHint,
        prefixIcon: const Icon(Icons.search, size: IconSizes.s20),
        suffixIcon: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => _controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: l10n.clearSearch,
                  icon: const Icon(Icons.close, size: IconSizes.s18),
                  onPressed: _clear,
                ),
        ),
      ),
    );
  }
}
