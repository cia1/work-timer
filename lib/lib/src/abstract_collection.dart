import 'dart:convert';

abstract class Collection<T> {

  final List<T> _entities = [];
  final T Function(Map<String,dynamic> json) _entityBuilder;
 
  Collection(this._entityBuilder);

  void loadFromString(String raw) {
    List<dynamic> json = jsonDecode(raw);
    for(dynamic entity in json) {
      add(_entityBuilder(entity));
    }
  }

  int get length => _entities.length;

  T? get(int index) {
    return index < _entities.length ? _entities[index] : null;
  }

  void add(T entity) {
    _entities.add(entity);
  }

  bool remove(int index) {
    if(_entities.length <= index) return false;
    _entities.removeAt(index);
    return true;
  }

  List<T> get entities => _entities;



  @override
  toString() => _entities.toString();

}