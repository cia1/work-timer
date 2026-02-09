import 'package:map_validation/map_validation.dart';
import 'package:timer_lib/src/abstract_factory.dart';
import 'group.dart';

class GroupFactory extends AbstractFactory<Group> {

  @override
  List<String> availalbeForCreate() => ['title', 'rate'];
  @override
  List<String> availableForUpdate() => availalbeForCreate();
  @override
  create() => Group.fromJson(json);

  @override
  List<Validator> validator(bool isCreate) {
    return [
      StringValidator(fieldName: 'title', isRequired: isCreate, requiredMessage: 'Title is required'),
      NumberValidator(fieldName: 'rate'),
    ];
  }

  GroupFactory(super.json);

  @override
  void fill(Group entity) {
    if(json.containsKey('title')) entity.title = json['title'];
    if(json.containsKey('rate')) entity.rate = json['rate'];
  }

}