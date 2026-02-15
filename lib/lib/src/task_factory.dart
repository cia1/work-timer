import 'package:map_validation/map_validation.dart';
import 'package:timer_lib/src/abstract_factory.dart';
import 'group.dart';
import 'task.dart';
import 'validator/timestamp_validator.dart';

class TaskFactory extends AbstractFactory<Task> {

  @override
  List<String> availalbeForCreate() => ['group', 'title'];
  @override
  List<String> availableForUpdate() => availalbeForCreate();
  @override
  create() {
    if(json.containsKey('group')) {
      final group = json['group'] as Group;
      json['group'] = group.id;
      json['rate'] = group.rate;
    }
    return Task.fromJson(json);
  }

  @override
  List<Validator> validator(bool isCreate) {
    return [
      StringValidator(fieldName: 'title', isRequired: isCreate, requiredMessage: 'Title is required'),
      NumberValidator(fieldName: 'rate'),
      NumberValidator(fieldName: 'seconds', isInteger: true),
      TimestampValidator(fieldName: 'createAt'),
      TimestampValidator(fieldName: 'startAt'),
      TimestampValidator(fieldName: 'finishAt')
    ];
  }

  TaskFactory(super.json);
  TaskFactory.fromString(super.raw): super.fromString();

  @override
  void fill(Task entity) {
    if(json.containsKey('title')) entity.title = json['title'];
    if(json.containsKey('group')) entity.setGroup(json['group']);
  }

}