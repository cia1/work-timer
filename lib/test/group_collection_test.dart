import 'package:test/test.dart';
import 'package:timer_lib/src/group.dart';
import 'package:timer_lib/src/abstract_collection.dart';

class GroupCollection extends Collection<Group> {
  GroupCollection(): super(Group.fromJson);
}

void main() {

  test('group Collection.loadFromString()', () {
    const json = '''[
      {"id": 1, "title": "First", "rate": 12.5},
      {"id": 20, "title": "Second", "rate": null}
    ]''';
    final collection = GroupCollection();
    collection.loadFromString(json);

    expect(collection.length, 2);
    expect(collection.get(0)!.title, 'First');
    expect(collection.get(1)!.rate, null);
  });

}