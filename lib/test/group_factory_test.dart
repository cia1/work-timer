import 'package:test/test.dart';
import 'package:timer_lib/src/group_factory.dart';
import 'package:timer_lib/src/group.dart';

void main() {

  test('GroupFactory.validate() (unsuccess)', () {
    final factory = GroupFactory({'id': 10});
    expect(factory.validate(true), false);
    expect(factory.error, 'Field is required.');
  });

  test('GroupFactory.validate() (success)', () {
    final factory = GroupFactory({'title': 'Test group', 'rate': 12});
    expect(factory.validate(true), true);
    expect(factory.error, null);
  });

  test('GroupFactory.fill()', () {
    final group = Group.fromJson({'id': 2, 'title': 'Test group', 'rate': 2200});
    final factory = GroupFactory({'id': 3, 'title': 'Test group 2', 'rate': 2600});
    factory.fill(group);
    expect(group.id, 2);
    expect(group.title, 'Test group 2');
    expect(group.rate, 2600);

  });

}