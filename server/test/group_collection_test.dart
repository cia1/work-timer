import 'dart:io';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart' as lib;
import '../src/group_collection.dart';

void main() {

  test('GroupCollection.load()', () {
    GroupCollection collection = GroupCollection('not-exits.json');
    expect(collection.length, 0);

    final String rootPath = "${Directory.current.path}/test/mock/groups.json";
    collection = GroupCollection(rootPath);
    collection.load();
    expect(collection.length, 2);

    lib.Group group = collection.get(0);
    expect(group.id, 1);
    expect(group.title, "First");
    expect(group.rate, 12.5);
 });

  test('GroupCollection.addFromString()', () {
    final collection = GroupCollection('not-exists.json');
    collection.addFromString('{"id": 2, "title":"Some title"}');
    expect(collection.entities.length, equals(1));

    lib.Group group = collection.get(0);
    expect(group.rate, null);

    group = collection.create('{"title": "Without ID"}');
    expect(group.id, 3);
  });

  test('TaskCollection.save()', () async {
    final collection = GroupCollection('tmp-group.json');
    collection.addFromString('{"id": 1, "title": "First!"}');
    collection.addFromString('{"id": 2, "title": "Second!"}');
    await collection.save();

    final file = File('tmp-group.json');
    final json = file.readAsStringSync();
    expect(json, '[{"id":1,"title":"First!","rate":null}, {"id":2,"title":"Second!","rate":null}]');

    file.delete();
  });

}