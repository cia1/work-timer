import 'package:map_validation/map_validation.dart';

class TimestampValidator extends Validator<int> {

  bool nowDefault = false;

  TimestampValidator({super.locale = 'en', required super.fieldName, nowDefault});

  @override
  bool validate(int? value, [Map<String, dynamic>? _]) {
    if(value != null && (value < 1770891054 || value > 2212643454)) {
        addError(fieldName, customMessage: 'date invalid');
        return false;
      }
    return true;
  }

}