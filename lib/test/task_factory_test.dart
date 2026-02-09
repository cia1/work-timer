import 'package:test/test.dart';
import 'package:timer_lib/src/task_factory.dart';
import 'package:timer_lib/src/task.dart';

void main() {

  test('TaskFactory.validate() (unsuccess)', () {
    final json = {'group': 10, 'rate': 12};
    final factory = TaskFactory(json);
    expect(factory.validate(true), false);
    expect(factory.error, 'Field is required.');
  });

  test('TaskFactory.validate() (success)', () {
    final json = {'group': 10, 'title': 'Test task', 'rate': 12};
    final factory = TaskFactory(json);
    expect(factory.validate(true), true);
    expect(factory.error, null);
  });

  test('TaskFactory.make()', () {
    final json = {'title': 'Test task'};
    final factory = TaskFactory(json);
    final task = factory.make();
    expect(task.group, null);
    expect(task.title, 'Test task');
  });

  test('TaskCollection.fill()', () {
    final task = Task.fromJson({'title': 'Test task'});
    final factory = TaskFactory({'title': 'Test task 2', 'rate': 2600, 'seconds': 1000});
    factory.fill(task);
    expect(task.title, 'Test task 2');
    expect(task.seconds, 0);
    expect(task.rate, null);
  });

}