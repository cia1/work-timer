import 'dart:convert';
import 'dart:io';
import 'package:timer_lib/timer_lib.dart' as lib;

class Collection extends lib.Collection {

  final String fileName;

  Collection(this.fileName);

  lib.Task create(String json) {
    final task = lib.Task.fromJson(jsonDecode(json));
    add(task);
    return task;
  }

  void load() {
    final file = File(fileName);
    if(!file.existsSync()) return;
    List<dynamic> json = jsonDecode(file.readAsStringSync());
    for(dynamic task in json) {
      add(lib.Task.fromJson(task));
    }
  }

  lib.Task addFromString(String json) {
    lib.Task task = lib.Task.fromJson(jsonDecode(json));
    add(task);
    return task;
  }

  Future<void> save() async {
    await File(fileName).writeAsString(this.tasks.toString());
  }

  @override
  String toString() {
    return tasks.toString();
  }

}