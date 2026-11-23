import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:capture/features/shell/presentation/widgets/notion_chip.dart';
import 'package:material_ui/material_ui.dart';

/// Wordmark, destinations and Notion state.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.destinations,
    required this.notionConnected,
    required this.onNotion,
    super.key,
  });

  final List<Widget> destinations;
  final bool notionConnected;
  final VoidCallback onNotion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: Sizes.sidebarWidth,
      color: context.paper.sidebar,
      padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.xxxl, Spacing.md, Spacing.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
            child: Underlined(l10n.appTitle, style: context.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Spacing.xl),
            child: Column(children: destinations),
          ),
          const Spacer(),
          NotionChip(
            key: const ValueKey(AppWidgetKeys.notionChip),
            connected: notionConnected,
            onTap: onNotion,
          ),
        ],
      ),
    );
  }
}
