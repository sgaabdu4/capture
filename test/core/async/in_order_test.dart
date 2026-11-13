import 'dart:async';

import 'package:capture/core/async/in_order.dart';
import 'package:flutter_test/flutter_test.dart';

const _why = 'Each step needs the one before it to finish first.';

void main() {
  test('starts each step only after the step before it has finished', () async {
    final events = <String>[];
    final gates = [Completer<void>(), Completer<void>(), Completer<void>()];

    final done = inOrder([0, 1, 2], (item) async {
      events.add('start $item');
      await gates[item].future;
      events.add('end $item');
    }, reason: _why);
    await pumpEventQueue();
    expect(events, ['start 0']);

    gates[0].complete();
    await pumpEventQueue();
    expect(events, ['start 0', 'end 0', 'start 1']);

    gates[1].complete();
    gates[2].complete();
    await done;
    expect(events, ['start 0', 'end 0', 'start 1', 'end 1', 'start 2', 'end 2']);
  });

  test('stops at the first failure and rethrows that error', () async {
    final started = <int>[];
    final failure = StateError('second step failed');

    await expectLater(
      inOrder([1, 2, 3], (item) {
        started.add(item);
        return item == 2 ? Future<void>.error(failure) : Future<void>.value();
      }, reason: _why),
      throwsA(same(failure)),
    );

    expect(started, [1, 2]);
  });

  test('runs nothing for no items', () async {
    int calls = 0;

    await inOrder(<int>[], (_) async => calls++, reason: _why);

    expect(calls, 0);
  });
}
