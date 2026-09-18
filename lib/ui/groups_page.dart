import 'package:flutter/material.dart';

import '../app/app_model.dart';
import '../domain/models.dart';
import 'theme.dart';
import 'widgets.dart';

/// Groups editor. Names and descriptions steer Jev's filing, so each group
/// explains what belongs in it. Groups are archived, never deleted, so
/// existing library relations stay valid.
class GroupsPage extends StatelessWidget {
  const GroupsPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([model.settings, model.library]),
    builder: (context, _) {
      final s = model.settings;
      if (!s.notionConnected) {
        return const PageFrame(
          title: 'Groups',
          children: [EmptyNote('Connect Notion in Settings to manage groups.')],
        );
      }
      final active = s.activeGroups;
      final archived = [
        for (final g in s.groups)
          if (g.archived) g,
      ];
      return PageFrame(
        title: 'Groups',
        subtitle:
            'Jev files each thought into one group using these descriptions. '
            'Describe what belongs, and what does not.',
        actions: [
          LinkButton(
            'Refresh',
            onPressed: () => _run(context, s.refreshGroups()),
          ),
          const SizedBox(width: 8),
          InkButton('Add group', onPressed: () => _edit(context, null)),
        ],
        children: [
          for (final g in active)
            _GroupCard(model: model, group: g, onEdit: () => _edit(context, g)),
          if (archived.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Archived', style: Styles.label),
            const SizedBox(height: 8),
            for (final g in archived)
              _GroupCard(
                model: model,
                group: g,
                onEdit: () => _edit(context, g),
              ),
          ],
        ],
      );
    },
  );

  Future<void> _run(BuildContext context, Future<String?> call) async {
    final error = await call;
    if (error != null && context.mounted) showNotice(context, error);
  }

  Future<void> _edit(BuildContext context, Group? group) => showDialog<void>(
    context: context,
    builder: (_) => _GroupDialog(model: model, group: group),
  );
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.model,
    required this.group,
    required this.onEdit,
  });
  final AppModel model;
  final Group group;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final e in model.library.entries)
        if (e.groupId == group.id) e,
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: PaperCard(
        padding: const EdgeInsets.fromLTRB(24, 18, 16, 18),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            shape: const Border(),
            title: Text(
              group.name,
              style: Styles.cardTitle.copyWith(
                color: group.archived ? Palette.muted : Palette.ink,
              ),
            ),
            subtitle: Text(group.description, style: Styles.label),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${items.length} saved', style: Styles.small),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                ),
              ],
            ),
            children: [
              if (items.isEmpty) const EmptyNote('Nothing saved here yet.'),
              for (final e in items.take(20))
                ListTile(
                  dense: true,
                  leading: Icon(
                    e.kind == ItemKind.task
                        ? Icons.check_box_outlined
                        : Icons.description_outlined,
                    color: Palette.ink,
                  ),
                  title: Text(e.title, style: Styles.body),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupDialog extends StatefulWidget {
  const _GroupDialog({required this.model, required this.group});
  final AppModel model;
  final Group? group;

  @override
  State<_GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<_GroupDialog> {
  late final _name = TextEditingController(text: widget.group?.name);
  late final _description = TextEditingController(
    text: widget.group?.description,
  );
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save({bool? archived}) async {
    setState(() => _busy = true);
    final s = widget.model.settings;
    final g = widget.group;
    final error = g == null
        ? await s.addGroup(_name.text, _description.text)
        : await s.updateGroup(
            g.copyWith(
              name: _name.text.trim(),
              description: _description.text.trim(),
              archived: archived ?? g.archived,
            ),
          );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.group;
    return AlertDialog(
      title: Text(
        g == null ? 'New group' : 'Edit group',
        style: Styles.cardTitle,
      ),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'What belongs here',
                errorText: _error,
                errorMaxLines: 2,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (g != null && !g.isUnsorted)
          LinkButton(
            g.archived ? 'Restore' : 'Archive',
            onPressed: _busy ? null : () => _save(archived: !g.archived),
          ),
        LinkButton('Cancel', onPressed: () => Navigator.of(context).pop()),
        InkButton('Save', onPressed: _save, busy: _busy),
      ],
    );
  }
}
