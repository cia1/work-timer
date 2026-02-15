import 'package:timer_lib/timer_lib.dart' as lib;
import '../app.dart';

class GroupFactory extends lib.GroupFactory {

  GroupFactory(super.json);
  GroupFactory.fromString(super.raw): super.fromString();

  @override
  lib.Group create() {
    final collection = App().groupCollection;
    json['id'] = collection.nextID();
    return super.create();
  }

}