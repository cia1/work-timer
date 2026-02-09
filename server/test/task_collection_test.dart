import 'dart:io';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart' as lib;
import '../src/task_collection.dart';

void main() {

  test('TaskCollection.load()', () {
    final String rootPath = "${Directory.current.path}/test/mock/tasks.json";
    final collection = TaskCollection(rootPath);
    collection.load();
    expect(collection.length, 3);

    lib.Task task = collection.get(0);
    expect(task.title, 'First job');
    expect(task.seconds, 0);
    expect(task.startAt, null);
    expect(task.finishAt, null);

    task = collection.get(1);
    expect(task.seconds, 6400);
    expect(task.startAt, DateTime.fromMillisecondsSinceEpoch(1766653535 * 1000));
    expect(task.finishAt, DateTime.fromMillisecondsSinceEpoch(1766649930 * 1000));
  });

  test('TaskCollection.addFromString()', () {
    final collection = TaskCollection('not-exists.json');
    expect(collection.entities.length, equals(0));
    collection.addFromString('{"title":"Some title"}');
    expect(collection.entities.length, equals(1));

    final now = DateTime.now();
    final lib.Task task = collection.get(0);
    expect(task.createAt.isBefore(now), true);
    expect(task.seconds, 0);
    expect(task.startAt, null);
    expect(task.finishAt, null);
  });

    test('TaskCollection.save()', () async {
        final collection = TaskCollection('tmp-task.json');
        final int now = (DateTime.now().millisecondsSinceEpoch / 1000).round();

        collection.addFromString('{"title": "First job"}');
        collection.addFromString('{"title": "Second job", "seconds": 6400, "startAt": 1766653535}');
        await collection.save();

        final file = File('tmp-task.json');
        final json = file.readAsStringSync();
        expect(json, '[{"title":"First job","seconds":0,"createAt":$now,"startAt":null,"finishAt":null}, {"title":"Second job","seconds":6400,"createAt":$now,"startAt":1766653535,"finishAt":null}]');

        file.delete();
    });

}