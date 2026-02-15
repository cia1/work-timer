import 'package:test/test.dart';
import '../src/app.dart';
import '../src/entities/task_factory.dart';

void main() {

  test('TaskFactory.make() withot group', () {
    final factory = TaskFactory({'title': 'Test task'});
    final task = factory.make();
    expect(task.title, 'Test task');
    expect(task.group, null);
    expect(task.seconds, 0);
 });

  test('TaskFactory.validate()', () {
    App.create('test/mock');
    final factory = TaskFactory({'group': 12, 'title': 'Not exists group task'});
    expect(factory.validate(true), false);
    expect(factory.error, 'Group not found');
  });

  test('TaskFactory.make() with group', () {
    App.create('test/mock');
    final factory = TaskFactory({'group': 3, 'title': 'Test task'});
    final task = factory.make();
    expect(task.group, 3);
    expect(task.rate, 2600);
  });

}