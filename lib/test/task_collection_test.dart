import 'package:test/test.dart';
import 'package:timer_lib/src/task.dart';
import 'package:timer_lib/src/abstract_collection.dart';

class TaskCollection extends Collection<Task> {
  TaskCollection(): super(Task.fromJson);
}

void main() {

  test('task Collection.loadFromString()', () {
    final collection = TaskCollection();
    collection.loadFromString('''[
      {"group": null, "title": "First", "rate": null, "seconds": 0, "createAt": 1770629341, "startAt": 1770629341},
      {"group": 2, "title": "Second", "rate": 2600, "seconds": 1000, "createAt": 1770630000, "finishAt": 1770629341}
    ]''');

    expect(collection.length, 2);
    expect(collection.get(0)!.title, 'First');
    expect(collection.get(0)!.rate, null);
    expect(collection.get(1)!.seconds, 1000);
    expect(collection.get(1)!.rate, 2600);
  });

  test('task Collection.add()', () {
    final collection = TaskCollection();
    expect(collection.length, 0);

    collection.add(Task('Some'));
    expect(collection.length, 1);
  });

  test('task Collection.remove()', () {
    final collection = TaskCollection();
    collection.loadFromString('''[
      {"group": null, "title": "First", "rate": null, "seconds": 0, "createAt": 1770629341, "startAt": 1770629341},
      {"group": 2, "title": "Second", "rate": 2600, "seconds": 1000, "createAt": 1770630000, "finishAt": 1770629341}
    ]''');
    expect(collection.remove(5), false);
    collection.remove(0);
    expect(collection.length, 1);
    expect(collection.get(0)!.title, 'Second');
  });

}