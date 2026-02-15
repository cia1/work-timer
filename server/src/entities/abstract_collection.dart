import 'dart:io';
import 'package:timer_lib/timer_lib.dart' as lib;

abstract class AbstractCollection<T> extends lib.Collection<T> {

  final String fileName;

  AbstractCollection(super.entityBuilder, this.fileName);

  void load() {
    final file = File(fileName);
    if(!file.existsSync()) return;
    loadFromString(file.readAsStringSync());
  }

  Future<void> save() async {
    final i = fileName.lastIndexOf('/');
    if(i >= 0) {
      final path = fileName.substring(0, i);
      final Directory directory = Directory(path);
      if(!directory.existsSync()) directory.createSync(recursive: true);
    }
    await File(fileName).writeAsString(toString());
  }

}