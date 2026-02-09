import 'dart:convert';
import 'package:timer_lib/timer_lib.dart' as lib;
import 'collection.dart';

class GroupCollection extends Collection<lib.Group> {

  GroupCollection(String fileName): super(lib.Group.create, fileName);

  @override
  lib.Group create(String json) {
    final group = jsonDecode(json);
    if(!group.containsKey('id')) {
      group['id'] = entities.fold<int>(1, (id, entity) => entity.id >= id ? entity.id + 1 : id);
    }
    final entity = entityFromJson(group);
    add(entity);
    return entity;
  }

  lib.Group? find(int id) {
    try {
      return entities.firstWhere((entity) => entity.id == id);
    } catch(_) {
      return null;
    }
  }

  int? findIndex(int id) {
    int index = entities.indexWhere((entity) => entity.id == id);
    return index == -1 ? null : index;
  }

}