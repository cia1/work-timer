import 'dart:convert';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';

void main() {

  final now = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  final Task task = Task('Title');

  test('Task.fromJson()', () {
    final now = DateTime.now();

    Task task = Task.fromJson({'title': 'Test task 1'});
    expect(task.title, 'Test task 1');
    expect(task.enabled, false);
    expect(task.createAt.isAfter(now), true);
    expect(task.startAt, null);
    expect(task.finishAt, null);

    task = Task.fromJson({
      'title': 'Test task 2',
      'seconds': 36000,
      'createAt': 1766222958,
      'startAt': 1766223008,
      'finishAt': 1765223008
    });
    expect(task.seconds, 36000);
    expect(task.createAt.isBefore(now), true);
    expect(task.startAt, DateTime.fromMillisecondsSinceEpoch(1766223008000));
    expect(task.finishAt, DateTime.fromMillisecondsSinceEpoch(1765223008000));
    expect(task.enabled, false);
  });

  test('Task.default()', () {
    expect(task.createAt.isBefore(DateTime.now()), true);
    expect(task.enabled, false);
  });

  test('Task.start()', () {
    task.start();
    expect(task.enabled, true);
    expect(task.startAt, isNot(null));
  });
  test('Task.stop()', () {
    task.stop();
    expect(task.enabled, false);
    expect(task.startAt, null);
  });

  test('Task.increaseTime()', () {
    final int time = task.seconds;
    task.increaseTime(36000);
    expect(task.seconds, time + 36000);
  });

  test('Task decreaseTime()', () {
    final time = task.seconds;
    task.decreaseTime(3600);
    expect(task.seconds, time - 3600);

    task.decreaseTime(90000);
    expect(task.seconds, 0);
  });

  test('Task reset()', () {
    task.increaseTime(10);
    task.reset();
    expect(task.seconds, 0);
  });

  test('Task.toString()', () {
    expect(task.toString(), jsonEncode({
      'title': 'Title',
      'seconds': 0,
      'createAt': now,
      'startAt': null,
      'finishAt': now
    }));
  });

}