import 'dart:convert';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';

void main() {

  test('Task()', () {
    final now = DateTime.now();
    Task task = Task('Test task');
    expect(task.title, 'Test task');
    expect(task.enabled, false);
    expect(task.createAt.isAfter(now), true);
    expect(task.startAt, null);
    expect(task.finishAt, null);
  });

  test('Task.fromJson', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': 1765223008,
    });
    expect(task.group, 1);
    expect(task.rate, 2200);
    expect(task.seconds, 36000);
    expect(task.createAt, DateTime.fromMillisecondsSinceEpoch(1766222958000));
    expect(task.startAt, DateTime.fromMillisecondsSinceEpoch(1766223008000));
    expect(task.finishAt, DateTime.fromMillisecondsSinceEpoch(1765223008000));
    expect(task.enabled, false);
  });

  test('Task.start()', () {
    final task = Task('Task.start');
    task.start();
    expect(task.enabled, true);
    expect(task.startAt, isNot(null));
  });

  test('Task.stop()', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': null,
    });
    expect(task.enabled, true);
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    task.stop();
    expect(task.enabled, false);
    expect(task.seconds, now - 1766223008 + 36000);
    expect(task.startAt, null);
  });

  test('Task.increaseTime()', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': 1765223008,
    });
    task.increaseTime(36000);
    expect(task.seconds, 72000);
  });

  test('Task decreaseTime()', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': 1765223008,
    });
    task.decreaseTime(3600);
    expect(task.seconds, 32400);
    task.decreaseTime(90000);
    expect(task.seconds, 0);
  });

  test('Task reset()', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': null,
    });
    task.reset();
    expect(task.seconds, 0);
    expect(DateTime.now().difference(task.startAt!).inSeconds, 0);
  });

  test('Task.setGroup()', () {
    final task = Task.fromJson({
      'group': null,
      'title': 'Test task',
      'rate': null,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': null,
    });
    task.setGroup(Group(5, 'Some', 2200));
    expect(task.group, 5);
    expect(task.rate, 2200);
  });

  test('Task.toString()', () {
    final task = Task.fromJson({
      'group': 1,
      'title': 'Test task',
      'rate': 2200,
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': null,
    });

    expect(
      task.toString(),
      jsonEncode({
        'group': 1,
        'title': 'Test task',
        'rate': 2200,
        'seconds': 36000,
        'createAt': 1766222958,
        'startAt': 1766223008,
        'finishAt': null,
      }),
    );
  });

}