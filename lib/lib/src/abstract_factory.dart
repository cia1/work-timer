import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:map_validation/map_validation.dart';

abstract class AbstractFactory<T> {

  void fill(T entity);
  @protected
  List<Validator> validator(bool isCreate);
  @protected
  T create();

  Map<String, dynamic> json;
  String? _error;
  bool _filtered = false;
  bool _validated = false;
  AbstractFactory(this.json);
  AbstractFactory.fromString(String raw): this(jsonDecode(raw));

  bool validate(bool isCreate) {
    if(_validated) return error == null;
    _filter(isCreate);
    final validator = _createValidator(isCreate);
    try {
      validator.validate(json);
    } on ValidatorException catch(exception) {
      _error = exception.errors.values.first[0];
      return false;
    }
    _error = null;
    _validated = true;
    return true;
  }

  String? get error => _error;

  T make() {
    _filter(true);
    return create();
  }



  @protected
  List<String> availalbeForCreate() => [];
  @protected
  List<String> availableForUpdate() => [];



  void _filter(bool isCreate) {
    if(_filtered) return;
    var attributes = isCreate ? availalbeForCreate() : availableForUpdate();
    json.removeWhere((String attribute, _) => !attributes.contains(attribute));
    _filtered = true;
  }

  ValidatorSchema _createValidator(bool isCreate) {
    return ValidatorSchema({
      for(final element in validator(isCreate)) element.fieldName: element
    });
  }

}