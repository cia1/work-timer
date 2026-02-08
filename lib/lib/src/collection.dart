import 'dart:convert';

abstract class Collection<T> {

  final T Function(Map<String, dynamic> json) _entityBuilder;
  final List<T> entities = [];
 
  Collection(this._entityBuilder);

  void  fromString(String raw) {
    List<dynamic> json = jsonDecode(raw);
    for(dynamic entity in json) {
      add(entityFromJson(entity));
    }
  }

  int get length => entities.length;

  T entityFromJson(Map<String, dynamic> json) {
    return _entityBuilder(json);
  }

  T entityFromString(String json) {
    return entityFromJson(jsonDecode(json));
  }

  T get(int index) {
    return entities[index];
  }

  void add(T entity) {
    entities.add(entity);
  }

  void remove(int index) {
    entities.removeAt(index);
  }

}