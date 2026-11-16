import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/entities/group_problem.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:flutter_test/flutter_test.dart';

final _work = Group(id: .new('work'), name: .new('Work'), description: 'Meetings');

GroupProblem? _problem(String name, String description, {Group? editing}) =>
    groupProblem((name: name, description: description), [_work], editingId: editing?.id);

void main() {
  test('a good name and description can be saved', () {
    expect(_problem('Garden', 'Plants'), isNull);
  });

  test('a blank name is missing', () {
    expect(_problem('  ', 'Plants'), equals(GroupProblem.nameMissing));
  });

  test('a name over the limit is too long, one at the limit is fine', () {
    expect(_problem('a' * (maxGroupNameLength + 1), 'x'), equals(GroupProblem.nameTooLong));
    expect(_problem('a' * maxGroupNameLength, 'x'), isNull);
  });

  test('a blank description is missing', () {
    expect(_problem('Garden', '  '), equals(GroupProblem.descriptionMissing));
  });

  test('a name another group has is a duplicate whatever its case or spaces', () {
    expect(_problem(' work ', 'x'), equals(GroupProblem.duplicateName));
  });

  test('a group keeps its own name when edited', () {
    expect(_problem('Work', 'New text', editing: _work), isNull);
  });
}
