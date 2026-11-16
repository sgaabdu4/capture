import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/sample_workspace.dart';
import '../../../../helpers/test_fakes.dart';

const _nineThirty = DueDate(2026, 9, 18, hour: 9, minute: 30);
const _frame = Duration(milliseconds: 100);
const _settleLimit = Duration(seconds: 5);
const _pickedDay = '20';

LibraryEntry _task({DueDate? due = _nineThirty, DueDate? reminder}) => LibraryEntry(
  pageId: .new('page-1'),
  itemId: .new('item-1'),
  title: 'Call the dentist',
  kind: .task,
  groupId: .new('home'),
  due: due,
  reminder: reminder,
);

Future<void> _settle(WidgetTester tester) =>
    tester.pumpAndSettle(_frame, .sendSemanticsUpdate, _settleLimit);

Future<void> _show(WidgetTester tester, LibraryEntry entry) async {
  final container = ProviderContainer.test(
    overrides: [
      systemDatasourceProvider.overrideWithValue(FakeSystem()),
      groupsRepositoryProvider.overrideWithValue(SampleGroups()),
    ],
  );
  addTearDown(container.dispose);
  tester.view
    ..physicalSize = const Size(1240, 1600)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: EntryDialogScreen(entry: entry, body: null)),
      ),
    ),
  );
  await _settle(tester);
}

WhenRow _row(WidgetTester tester) => tester.widget<WhenRow>(find.byType(WhenRow));

Future<void> _tapSwitch(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey(AppWidgetKeys.whenReminderSwitch)));
  await _settle(tester);
}

Future<void> _openDayPicker(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey(AppWidgetKeys.whenDateButton)));
  await _settle(tester);
}

Finder _pickerButtons() =>
    find.descendant(of: find.byType(DatePickerDialog), matching: find.byType(TextButton));

void main() {
  testWidgets('the reminder switch turns the reminder on at the due time', (tester) async {
    await _show(tester, _task());
    expect(_row(tester).hasReminder, isFalse);

    await _tapSwitch(tester);

    expect(_row(tester).hasReminder, isTrue);
  });

  testWidgets('the reminder switch turns an existing reminder off', (tester) async {
    await _show(tester, _task(reminder: _nineThirty));
    expect(_row(tester).hasReminder, isTrue);

    await _tapSwitch(tester);

    expect(_row(tester).hasReminder, isFalse);
  });

  testWidgets('a picked day replaces the date and keeps the time', (tester) async {
    await _show(tester, _task());

    await _openDayPicker(tester);
    await tester.tap(
      find.descendant(of: find.byType(DatePickerDialog), matching: find.text(_pickedDay)),
    );
    await tester.tap(_pickerButtons().last);
    await _settle(tester);

    expect(_row(tester).due, equals(const DueDate(2026, 9, 20, hour: 9, minute: 30)));
  });

  testWidgets('cancelling the day picker leaves the date alone', (tester) async {
    await _show(tester, _task());

    await _openDayPicker(tester);
    await tester.sendKeyEvent(.escape);
    await _settle(tester);

    expect(_row(tester).due, equals(_nineThirty));
  });
}
