import 'package:timer_lib/timer_lib.dart';
import 'abstract_collection.dart';

class TaskCollection extends AbstractCollection<Task> {

  TaskCollection(String fileName): super(Task.fromJson, fileName);

  bool unsetGroup(int id) {
    bool changes = false;
    for(final entity in entities) {
      if(entity.group == id) {
        entity.group = null;
        changes = true;
      }
    }
    return changes;
  }

}