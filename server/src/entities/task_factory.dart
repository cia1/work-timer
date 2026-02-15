import 'package:map_validation/src/validator.dart';
import 'package:timer_lib/timer_lib.dart' as lib;

import 'group_validator.dart';

class TaskFactory extends lib.TaskFactory {

  TaskFactory(super.json);
  TaskFactory.fromString(super.raw): super.fromString();

  @override
  lib.Task make() {
    validate(true);
    return super.make();
  }

  @override
  List<Validator<dynamic>> validator(bool isCreate) {
    final validators = super.validator(isCreate);
    validators.add(GroupValidator(fieldName: 'group'));
    return validators;
  }

}