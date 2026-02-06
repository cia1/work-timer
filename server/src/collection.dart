import 'dart:io';
import 'package:timer_lib/timer_lib.dart' as lib;

abstract class Collection<T> extends lib.Collection<T> {

  final String fileName;

  Collection(super.entityBuilder, this.fileName);

  T create(String json) {
    final entity = entityFromString(json);
    add(entity);
    return entity;
  }

  void load() {
    final file = File(fileName);
    if(!file.existsSync()) return;
    fromString(file.readAsStringSync());
  }

  T addFromString(String json) {
    final T entity = entityFromString(json);
    add(entity);
    return entity;
  }

  @override
  String toString() {
    return entities.toString();
  }

  Future<void> save() async {
    final i = fileName.lastIndexOf('/');
    if(i >= 0) {
      final path = fileName.substring(0, i);
      final Directory directory = Directory(path);
      if(!directory.existsSync()) directory.createSync(recursive: true);
    }
    await File(fileName).writeAsString(entities.toString());
  }

}