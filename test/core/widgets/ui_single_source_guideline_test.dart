import 'dart:io';

import 'package:capture/app/phone_localizations.dart';
import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/core/theme/fonts.dart';
import 'package:capture/core/theme/overlay_tokens.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/icon_action.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/atoms/paper_checkbox.dart';
import 'package:capture/core/widgets/atoms/paper_dropdown.dart';
import 'package:capture/core/widgets/atoms/paper_field.dart';
import 'package:capture/core/widgets/atoms/paper_segmented.dart';
import 'package:capture/core/widgets/atoms/paper_switch.dart';
import 'package:capture/core/widgets/expandable_card.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/screens/recordings_screen.dart';
import 'package:capture/features/capture/presentation/widgets/capture_actions.dart';
import 'package:capture/features/capture/presentation/widgets/capture_card.dart';
import 'package:capture/features/capture/presentation/widgets/delete_capture_dialog.dart';
import 'package:capture/features/capture/presentation/widgets/group_menu.dart';
import 'package:capture/features/capture/presentation/widgets/kind_toggle.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_editor.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_header.dart';
import 'package:capture/features/capture/presentation/widgets/review_card.dart';
import 'package:capture/features/capture/presentation/widgets/today_card.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/groups/presentation/widgets/group_card.dart';
import 'package:capture/features/groups/presentation/widgets/group_dialog.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:capture/features/library/presentation/widgets/entry_dialog_actions.dart';
import 'package:capture/features/library/presentation/widgets/entry_row.dart';
import 'package:capture/features/library/presentation/widgets/search_field.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/notion_step_screen.dart';
import 'package:capture/features/settings/presentation/screens/shortcut_section_screen.dart';
import 'package:capture/features/settings/presentation/screens/typesafe_step_screen.dart';
import 'package:capture/features/settings/presentation/widgets/auto_save_section.dart';
import 'package:capture/features/settings/presentation/widgets/field_row.dart';
import 'package:capture/features/settings/presentation/widgets/model_step.dart';
import 'package:capture/features/settings/presentation/widgets/notion_guide_dialog.dart';
import 'package:capture/features/settings/presentation/widgets/privacy_section.dart';
import 'package:capture/features/settings/presentation/widgets/reset_dialog.dart';
import 'package:capture/features/settings/presentation/widgets/speech_credit_dialog.dart';
import 'package:capture/features/shell/presentation/screens/app_shell_screen.dart';
import 'package:capture/features/shell/presentation/widgets/app_sidebar.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:capture/features/shell/presentation/widgets/bottom_nav_item.dart';
import 'package:capture/features/shell/presentation/widgets/notion_chip.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/sample_workspace.dart';
import '../../helpers/test_fakes.dart';

const _frame = Duration(milliseconds: 16);
const _settleLimit = Duration(seconds: 5);

void _noop() {}

void _ignore(Object? _) {}

ProviderContainer _makeContainer() => .test(
  overrides: [
    nativePlatformServiceProvider.overrideWithValue(stubNative()),
    settingsProvider.overrideWithBuild(readySettings),
    groupsRepositoryProvider.overrideWithValue(SampleGroups()),
  ],
);

Widget _harness(
  ProviderContainer container,
  Widget child, {
  List<LocalizationsDelegate<Object?>>? delegates,
}) => UncontrolledProviderScope(
  container: container,
  child: MaterialApp(
    theme: buildAppTheme(),
    localizationsDelegates: delegates ?? AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

Future<void> _pumpAndCheckGuidelines(
  WidgetTester tester,
  Widget widget, {
  Size viewport = referenceWindow,
  bool checkAndroidTargets = true,
  ProviderContainer? provided,
  List<LocalizationsDelegate<Object?>>? delegates,
}) async {
  final container = provided ?? _makeContainer();
  addTearDown(container.dispose);
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final semantics = tester.ensureSemantics();
  try {
    await tester.pumpWidget(_harness(container, widget, delegates: delegates));
    await tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    if (checkAndroidTargets) {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    }
  } finally {
    semantics.dispose();
  }
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('shared library controls meet accessibility guidelines and forward actions', (
    tester,
  ) async {
    bool tapped = false;
    bool checked = false;
    bool switched = false;
    String? picked;
    String segment = 'a';
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await _pumpAndCheckGuidelines(
      tester,
      Column(
        children: [
          IconAction(Icons.edit_outlined, tooltip: 'Edit item', onPressed: () => tapped = true),
          PaperCheckbox(
            value: checked,
            semanticLabel: 'Include item',
            onChanged: (v) => checked = v,
          ),
          PaperSwitch(value: switched, semanticLabel: 'Remind me', onChanged: (v) => switched = v),
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
    );

    await tester.tap(find.byType(IconAction));
    await tester.tap(find.byType(PaperCheckbox));
    await tester.tap(find.byType(PaperSwitch));
    await tester.tap(
      find.descendant(of: find.byType(PaperSegmented<String>), matching: find.byType(Text)).last,
    );
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
      Column(
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
          KindToggle(kind: .task, onChanged: (_) {}),
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
        ],
      ),
    );
  });

  testWidgets('iPhone review card and delete dialog meet accessibility guidelines', (tester) async {
    await _pumpAndCheckGuidelines(
      tester,
      const Column(
        children: [
          // ReviewCardButton uses the fixed 46 pt height mirrored from macOS Overlay.swift on iPhone.
          ReviewCard(
            countLine: '1 item',
            rows: [(icon: Icons.check_box_outlined, title: 'Book MOT', detail: 'Home')],
            canApprove: true,
            onYes: _noop,
            onNo: _noop,
            onEdit: _noop,
            onLater: _noop,
          ),
          DeleteCaptureDialog(
            saved: true,
            detail: '20 minutes ago · 0:14',
            onCancel: _noop,
            onDelete: _noop,
          ),
        ],
      ),
      checkAndroidTargets: false,
    );
  });

  testWidgets('changed groups and library widgets meet accessibility guidelines', (tester) async {
    await _pumpAndCheckGuidelines(
      tester,
      Column(
        children: [
          GroupCard(
            group: sampleGroups.first,
            items: sampleEntries.take(1).toList(),
            busy: false,
            onEdit: _noop,
            onOpenEntry: (_) {},
            onArchive: _noop,
          ),
          EntryRow(entry: sampleEntries.first, onChanged: (_) {}, onOpen: _noop),
          SearchField(query: 'tomato', onChanged: (_) {}),
          GroupDialog(groups: sampleGroups, onSave: (_) {}, onCancel: _noop),
        ],
      ),
    );
    expect(find.byType(IconAction), findsWidgets);
  });

  testWidgets('changed settings and entry dialog screens meet accessibility guidelines', (
    tester,
  ) async {
    await _pumpAndCheckGuidelines(
      tester,
      Column(
        children: [
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
        ],
      ),
    );
  });

  testWidgets('changed modal dialogs and shell meet accessibility guidelines', (tester) async {
    await _pumpAndCheckGuidelines(
      tester,
      EntryDialogScreen(entry: sampleEntries.first, body: 'Seedling details'),
    );
    await _pumpAndCheckGuidelines(tester, const NotionGuideDialog(onClose: _noop));
    await _pumpAndCheckGuidelines(tester, const ResetDialog(onCancel: _noop, onReset: _noop));
    await _pumpAndCheckGuidelines(
      tester,
      AppShellScreen(
        location: '/',
        child: Center(child: Text(NotionId('home').value)),
      ),
      viewport: const Size(390, 844),
    );
  });

  testWidgets('page frames and saved labels meet accessibility guidelines', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    await _pumpAndCheckGuidelines(
      tester,
      ColoredBox(
        color: Palette.paper,
        child: PageFrame(
          title: 'Groups',
          subtitle: l10n.syncRefreshing,
          actions: const [LinkButton('Refresh', onPressed: _noop)],
          children: [
            Text(sampleSavedCapture.identity(l10n, FakeSystem.now)),
            Text(sampleEntries.first.detail(l10n, FakeSystem.now, null) ?? ''),
          ],
        ),
      ),
      viewport: const Size(390, 844),
    );
  });

  testWidgets('field rows, entry actions, shortcut and credit meet accessibility guidelines', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await _pumpAndCheckGuidelines(
      tester,
      Column(
        children: [
          FieldRow(
            field: PaperField(
              controller: controller,
              label: 'Key',
              decoration: const InputDecoration(),
            ),
            action: const InkButton('Save', onPressed: _noop),
          ),
          const EntryDialogActions(
            confirmingDelete: false,
            onAskDelete: _noop,
            onDelete: _noop,
            onCancel: _noop,
            onSave: _noop,
          ),
          ShortcutSectionScreen(
            label: '⌃⌥',
            registered: true,
            problem: null,
            onShortcut: (_) {},
            onRecording: (_) {},
          ),
        ],
      ),
      viewport: const Size(390, 844),
    );
    await _pumpAndCheckGuidelines(tester, const SpeechCreditDialog());
  });

  testWidgets('Settings marks no bottom destination as the page on screen', (tester) async {
    await _pumpAndCheckGuidelines(
      tester,
      const AppShellScreen(location: '/settings', child: SizedBox.shrink()),
      viewport: const Size(390, 844),
    );
    final marked = tester
        .widgetList<BottomNavItem>(find.byType(BottomNavItem))
        .where((item) => item.selected);
    expect(marked, isEmpty);
    await _pumpAndCheckGuidelines(
      tester,
      const SizedBox(
        height: 80,
        child: BottomNavBar(destinations: [], selected: null, onSelected: _ignore),
      ),
      viewport: const Size(390, 844),
    );
  });

  testWidgets('recordings cards, link buttons and the sidebar meet accessibility guidelines', (
    tester,
  ) async {
    await _pumpAndCheckGuidelines(
      tester,
      Column(
        children: [
          for (final record in [sampleSavedCapture, sampleProposedCapture])
            CaptureCard(
              record: record,
              nowUtc: FakeSystem.now,
              busy: false,
              idle: true,
              onRetry: _noop,
              onReview: _noop,
              onRetrySave: _noop,
              onReviewAgain: _noop,
              onDelete: _noop,
            ),
          const ExpandableCard(title: Text('Plain card'), children: []),
          const LinkButton('Link', onPressed: _noop),
        ],
      ),
      viewport: const Size(390, 844),
    );
    final link = find.ancestor(of: find.text('Link'), matching: find.byType(LinkButton));
    expect(tester.getSize(link).height, greaterThanOrEqualTo(Sizes.tapTarget));

    await _pumpAndCheckGuidelines(
      tester,
      const SizedBox(
        height: 800,
        child: AppSidebar(destinations: [], notionConnected: true, onHome: _noop, onNotion: _noop),
      ),
    );
    await _pumpAndCheckGuidelines(
      tester,
      const Center(child: NotionChip(connected: false, onTap: _noop)),
      viewport: const Size(390, 844),
    );
  });

  testWidgets('the Recordings page meets accessibility guidelines', (tester) async {
    final support = Directory.systemTemp.createTempSync('capture_guideline');
    addTearDown(() => support.deleteSync(recursive: true));
    final container = ProviderContainer.test(
      overrides: [
        ...appOverrides(support: support, native: stubNative()),
        settingsProvider.overrideWithBuild(readySettings),
      ],
    );
    container.read(captureRepositoryProvider)
      ..put(sampleSavedCapture)
      ..put(sampleProposedCapture);

    await _pumpAndCheckGuidelines(
      tester,
      const RecordingsScreen(),
      provided: container,
      viewport: const Size(390, 844),
    );
  });

  testWidgets('iPhone wording for the speech credit and privacy meets guidelines', (tester) async {
    await _pumpAndCheckGuidelines(
      tester,
      const Column(
        children: [
          ModelStep(ready: true, download: null, totalBytes: 1, onDownload: _noop),
          PrivacySection(),
        ],
      ),
      viewport: const Size(390, 844),
      delegates: PhoneLocalizationsDelegate.delegates,
    );
  });
}
