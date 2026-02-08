import 'package:timer_lib/timer_lib.dart' as lib;
import 'collection.dart';

class ProjectCollection extends Collection<lib.Project> {

  ProjectCollection(String fileName): super(lib.Project.create, fileName);

}