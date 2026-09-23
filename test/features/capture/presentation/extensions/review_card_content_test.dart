import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/presentation/extensions/review_card_content.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_state.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final _l10n = lookupAppLocalizations(const .new('en'));

final _groups = GroupsState(
  groups: [.new(id: .new('g1'), name: .new('Work'), description: 'Job things')],
);

ProposalItem _item(String id, {String? groupId = 'g1', DueDate? due, bool task = false}) => .new(
  id: .new(id),
  sources: const [],
  kind: task ? .task : .note,
  groupId: groupId == null ? null : .new(groupId),
  title: 'Item $id',
  body: '',
  due: due,
);

CaptureRecord _record(List<ProposalItem> items, {CaptureFailure? failure}) => .new(
  id: .new('c1'),
  capturedAtUtc: .utc(2026, 9, 18, 9),
  timeZone: .new('Europe/London'),
  audioPath: .new('c1.pcm'),
  stage: .proposed,
  items: items,
  failure: failure,
);

void main() {
  final l10n = _l10n;
  final groups = _groups;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting('en');
  });

  test('counts only included items and allows approval when nothing blocks it', () {
    final card = _record([
      _item('a'),
      _item('b', task: true, due: const .new(2026, 9, 19, hour: 9, minute: 0)),
      _item('c').withIncluded(value: false),
    ]).reviewCard(l10n, groups);

    expect(card.countLine, equals('1 note · 1 task'));
    expect(card.rows.map((r) => r.id), equals(['a', 'b']));
    expect(card.canApprove, isTrue);
    expect(card.blockedReason, isNull);
  });

  test('rows show kind, group and relative date in the capture time zone', () {
    final card = _record([
      _item('a'),
      _item('b', task: true, due: const .new(2026, 9, 19, hour: 9, minute: 0)),
      _item('c', task: true),
    ]).reviewCard(l10n, groups);

    expect(card.rows.map((r) => r.icon), equals(['doc.text', 'calendar', 'checkmark.square']));
    expect(card.rows[1].detail, equals('Task · Work · Tomorrow 9:00\u202fAM'));
  });

  test('an item without a group blocks approval and says why', () {
    final card = _record([_item('a', groupId: null)]).reviewCard(l10n, groups);

    expect(card.canApprove, isFalse);
    expect(card.blockedReason, equals('Needs a look: Choose a group'));
  });

  test('a failed save is the reason shown on the card', () {
    final card = _record([_item('a')], failure: .notionAuth).reviewCard(l10n, groups);

    expect(card.blockedReason, equals(l10n.failureNotionAuth));
  });

  test('an empty proposal says nothing was caught and cannot be approved', () {
    final card = _record(const []).reviewCard(l10n, groups);

    expect(card.countLine, equals(l10n.reviewNothing));
    expect(card.canApprove, isFalse);
  });
}
