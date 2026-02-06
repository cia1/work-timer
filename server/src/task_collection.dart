import 'package:timer_lib/timer_lib.dart' as lib;
import 'collection.dart';

class TaskCollection extends Collection<lib.Task> {

  TaskCollection(String fileName): super(lib.Task.fromJson, fileName);

}