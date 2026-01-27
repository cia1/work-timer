import 'dart:convert';
import 'task.dart';

class Collection {

  Collection.fromString(String json) {
    final map = jsonDecode(json);
    if(map is! List) throw Exception('Bad data format');
    for(dynamic task in map) {
      add(Task.fromJson(task));
    }
  }

  Collection();

  final List<Task> tasks = [];

  int get length => tasks.length;
  List<Task> get all => tasks;

  Task get(int index) {
    return tasks[index];
  }

  void add(Task task) {
    tasks.add(task);
  }

  void remove(int index) {
    tasks.removeAt(index);
  }

}