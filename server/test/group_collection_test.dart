import 'dart:io';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';
import '../src/entities/group_collection.dart';

void main() {

  test('GroupCollection.load()', () {
    GroupCollection collection = GroupCollection('not-exits.json');
    expect(collection.length, 0);

    collection = GroupCollection('test/mock/groups.json');
    collection.load();
    expect(collection.length, 2);

    Group? group = collection.get(0);
    expect(group, isNotNull);
    expect(group!.id, 1);
    expect(group.title, "First");
    expect(group.rate, 2200);
 });

  test('GroupCollection.find()', () {
    final collection = GroupCollection("${Directory.current.path}/test/mock/groups.json")..load();
    expect(collection.find(5), null);
    final group = collection.find(3);
    expect(group, isNotNull);
    expect(group!.id, 3);
  });

  test('GroupCollection.delete()', () {
    final collection = GroupCollection('test/mock/groups.json');
    collection.load();
    expect(collection.delete(999), false);
    expect(collection.delete(1), true);
    expect(collection.length, 1);
    expect(collection.get(0)!.id, 3);
  });

  test('TaskCollection.save()', () async {
    final collection = GroupCollection("${Directory.current.path}/test/mock/groups.json.tmp");
    collection.add(Group(1, 'First', 2200));
    collection.add(Group(2, 'Second', 2600));
    await collection.save();

    final file = File("${Directory.current.path}/test/mock/groups.json.tmp");
    final json = file.readAsStringSync();
    expect(json, '[{"id":1,"title":"First","rate":2200}, {"id":2,"title":"Second","rate":2600}]');
    file.delete();
  });

}