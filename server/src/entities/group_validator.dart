import 'package:map_validation/map_validation.dart';
import '../app.dart';

class GroupValidator extends Validator<int> {

  GroupValidator({super.locale = 'en', required super.fieldName});

  @override
  bool validate(int? value, [Map<String, dynamic>? data]) {
    if(value == null) return true;
    final group = App().groupCollection.find(value);
    if(group == null) {
      addError(fieldName, customMessage: 'Group not found');
      return false;
    }
    if(data != null) data['group'] = group;
    return true;
  }

}