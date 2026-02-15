import 'package:timer_lib/timer_lib.dart' as lib;
import 'abstract_collection.dart';

class GroupCollection extends AbstractCollection<lib.Group> {

  GroupCollection(String fileName): super(lib.Group.fromJson, fileName);

  int nextID() => entities.fold<int>(1, (id, entity) => entity.id >= id ? entity.id + 1 : id);

  lib.Group? find(int id) {
    try {
      return entities.firstWhere((entity) => entity.id == id);
    } catch(_) {
      return null;
    }
  }

  bool delete(int id) {
    final index = _findIndex(id);
    if(index == null) return false;
    return remove(index);
  }



  int? _findIndex(int id) {
    int index = entities.indexWhere((entity) => entity.id == id);
    return index >= 0 ? index : null;
  }

}