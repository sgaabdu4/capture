import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/fonts.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/widgets/atoms/icon_action.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/paper_checkbox.dart';
import 'package:capture/core/widgets/atoms/paper_dropdown.dart';
import 'package:capture/core/widgets/atoms/paper_field.dart';
import 'package:capture/core/widgets/atoms/paper_segmented.dart';
import 'package:capture/core/widgets/atoms/paper_switch.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/presentation/widgets/capture_actions.dart';
import 'package:capture/features/capture/presentation/widgets/delete_capture_dialog.dart';
import 'package:capture/features/capture/presentation/widgets/group_menu.dart';
import 'package:capture/features/capture/presentation/widgets/kind_toggle.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_editor.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_header.dart';
import 'package:capture/features/capture/presentation/widgets/review_card.dart';
import 'package:capture/features/capture/presentation/widgets/today_card.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/features/groups/presentation/widgets/group_dialog.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:capture/features/library/presentation/widgets/entry_row.dart';
import 'package:capture/features/library/presentation/widgets/search_field.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/notion_step_screen.dart';
import 'package:capture/features/settings/presentation/screens/typesafe_step_screen.dart';
import 'package:capture/features/settings/presentation/widgets/auto_save_section.dart';
import 'package:capture/features/settings/presentation/widgets/notion_guide_dialog.dart';
import 'package:capture/features/settings/presentation/widgets/reset_dialog.dart';
import 'package:capture/features/shell/presentation/screens/app_shell_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/sample_workspace.dart';
import '../../helpers/test_fakes.dart';

void _noop() {}

Widget _harness(Widget child) => ProviderScope(
  overrides: [
    nativePlatformServiceProvider.overrideWithValue(stubNative()),
    settingsProvider.overrideWithBuild(readySettings),
    groupsRepositoryProvider.overrideWithValue(SampleGroups()),
  ],
  child: MaterialApp(
    theme: buildAppTheme(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

Future<void> _pumpAndCheckGuidelines(WidgetTester tester, Widget widget) async {
  final semantics = tester.ensureSemantics();
  try {
    await tester.pumpWidget(_harness(widget));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  } finally {
    semantics.dispose();
  }
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('shared library controls meet accessibility guidelines and forward actions', (
    tester,
  ) async {
    var tapped = false;
    var checked = false;
    var switched = false;
    String? picked;
    var segment = 'a';
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await _pumpAndCheckGuidelines(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [
            IconAction(Icons.edit_outlined, tooltip: 'Edit item', onPressed: () => tapped = true),
            PaperCheckbox(
              value: checked,
              semanticLabel: 'Include item',
              onChanged: (v) => checked = v,
            ),
            PaperSwitch(
              value: switched,
              semanticLabel: 'Remind me',
              onChanged: (v) => switched = v,
            ),
            PaperField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Secret key'),
            ),
            PaperDropdown<String>(
              value: picked,
              hint: 'Choose option',
              items: const [(value: 'one', label: 'One')],
              onChanged: (v) => picked = v,
            ),
            PaperSegmented<String>(
              options: const [(value: 'a', label: 'Alpha'), (value: 'b', label: 'Beta')],
              selected: segment,
              onChanged: (v) => segment = v,
            ),
            const PaperDialog(
              title: 'Confirm choice',
              content: Text('Body copy'),
              actions: [InkButton('Proceed', onPressed: _noop)],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(IconAction));
    await tester.tap(find.byType(PaperCheckbox));
    await tester.tap(find.byType(PaperSwitch));
    await tester.tap(find.text('Beta'));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(tapped, isTrue);
    expect(checked, isTrue);
    expect(switched, isTrue);
    expect(segment, equals('b'));
    expect(field.obscureText, isTrue);
    expect(field.autocorrect, isFalse);
    expect(field.enableSuggestions, isFalse);
    expect(Fonts.titleFamily, equals('Caveat'));
    expect(Fonts.handFamily, equals('Patrick Hand'));
    expect(OverlayTokens.cardTitle.fontFamily, equals(Fonts.titleFamily));
  });

  testWidgets('changed capture controls meet accessibility guidelines', (tester) async {
    final titleController = TextEditingController(text: 'Book the car');
    addTearDown(titleController.dispose);
    final item = sampleProposedCapture.items.first.copyWith(sources: const []);

    await _pumpAndCheckGuidelines(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [
            const CaptureActions(
              stage: .proposed,
              busy: false,
              idle: true,
              onRetry: _noop,
              onReview: _noop,
              onRetrySave: _noop,
              onReviewAgain: _noop,
              onDelete: _noop,
            ),
            GroupMenu(groups: sampleGroups, value: sampleGroups.first.id, onChanged: (_) {}),
            KindToggle(kind: ItemKind.task, onChanged: (_) {}),
            ProposalItemHeader(
              item: item,
              titleController: titleController,
              groups: sampleGroups,
              editable: true,
              onChanged: (_) {},
            ),
            ProposalItemEditor(
              item: item,
              groups: sampleGroups,
              today: FakeSystem.now,
              editable: true,
              onChanged: (_) {},
              onPickDate: _noop,
              onPickTime: _noop,
              onClearWhen: _noop,
              onReminder: (_) {},
              onSplit: (_) {},
              onMergeNext: null,
            ),
            TodayCard(
              items: const [(title: 'Water seedlings', due: 'Today', done: false)],
              onDoneChanged: (_, {required done}) {},
              onViewAll: _noop,
            ),
            WhenRow(
              due: item.due,
              hasReminder: true,
              today: FakeSystem.now,
              enabled: true,
              onPickDate: _noop,
              onPickTime: _noop,
              onClear: _noop,
              onReminder: (_) {},
            ),
            const ReviewCard(
              countLine: '1 item',
              rows: [(icon: Icons.check_box_outlined, title: 'Book MOT', detail: 'Home')],
              canApprove: true,
              onYes: _noop,
              onNo: _noop,
              onEdit: _noop,
              onLater: _noop,
            ),
            const DeleteCaptureDialog(saved: true, onCancel: _noop, onDelete: _noop),
          ],
        ),
      ),
    );
  });

  testWidgets('changed groups, library, settings and shell widgets meet accessibility guidelines', (
    tester,
  ) async {
    tester.view.physicalSize = referenceWindow;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpAndCheckGuidelines(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [
            GroupCard(
              group: sampleGroups.first,
              items: sampleEntries.take(1).toList(),
              busy: false,
              onEdit: _noop,
              onOpenEntry: (_) {},
              onArchive: _noop,
            ),
            GroupDialog(groups: sampleGroups, onSave: (_) {}, onCancel: _noop),
            EntryDialogScreen(entry: sampleEntries.first, body: 'Seedling details'),
            EntryRow(entry: sampleEntries.first, onChanged: (_) {}, onOpen: _noop),
            SearchField(query: '', onChanged: (_) {}),
            NotionStepScreen(
              connected: true,
              workspaceName: 'Workspace',
              hasToken: true,
              connecting: false,
              error: null,
              onConnect: ({required token, required pageLink}) {},
              onShowGuide: _noop,
            ),
            TypesafeStepScreen(hasKey: true, saving: false, error: null, onSave: (_) {}),
            AutoSaveSection(on: false, onChanged: (_) {}),
            const NotionGuideDialog(onClose: _noop),
            const ResetDialog(onCancel: _noop, onReset: _noop),
            SizedBox(
              height: referenceWindow.height,
              child: AppShellScreen(
                location: '/',
                child: Center(child: Text(NotionId('home').value)),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
