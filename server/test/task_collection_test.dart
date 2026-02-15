import 'dart:io';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';
import '../src/entities/task_collection.dart';

void main() {

  test('TaskCollection.load()', () {
    final collection = TaskCollection('test/mock/tasks.json')..load();
    expect(collection.length, 3);

    Task? task = collection.get(0);
    expect(task, isNotNull);
    expect(task!.title, 'First job');
    expect(task.seconds, 0);

    task = collection.get(100);
    expect(task, null);
  });

  test('TaskCollection.add()', () {
    final collection = TaskCollection('not-exists.json');
    expect(collection.length, 0);
    collection.add(Task('Second'));
    expect(collection.length, 1);
  });

  test('TaskCollection.unsetGroup()', () {
    final collection = TaskCollection('test/mock/tasks.json')..load();
    collection.unsetGroup(3);
    expect(collection.get(2)!.group, null);
    expect(collection.get(2)!.rate, 2600);
  });

  test('TaskCollection.save()', () async {
    final collection = TaskCollection('test/mock/tasks.json.tmp');
    final int now = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    collection.add(Task('Task 1'));
    collection.add(Task('Task 2'));
    await collection.save();

    final file = File('test/mock/tasks.json.tmp');
    final json = file.readAsStringSync();
    expect(json, '[{"group":null,"title":"Task 1","rate":null,"seconds":0,"createAt":$now,"startAt":null,"finishAt":null}, {"group":null,"title":"Task 2","rate":null,"seconds":0,"createAt":$now,"startAt":null,"finishAt":null}]');
    file.delete();
  });

}