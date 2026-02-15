import 'package:test/test.dart';
import '../src/app.dart';
import '../src/entities/group_factory.dart';

void main() {

  test('GroupFactory.make', () {
    App.create('test/mock');
    final factory = GroupFactory({'title': 'Test group', 'rate': 2600});
    final group = factory.make();
    expect(group.id, 4);
    expect(group.title, 'Test group');
    expect(group.rate, 2600);
 });

}