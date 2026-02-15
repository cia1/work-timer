import 'dart:async';
import 'package:shelf/shelf.dart';
import 'controller/abstract_controller.dart';
import 'controller/task_controller.dart';
import 'controller/group_controller.dart';
import 'http_exceptions.dart';
import 'entities/group_collection.dart';
import 'entities/task_collection.dart';

class App {

  static App? _self;

  late final String _rootPath;
  GroupCollection? _groupCollection;
  TaskCollection? _taskCollection;

  App._create(this._rootPath);

  factory App.create(String path) {
    if(!path.endsWith('/')) path = '$path/';
    return _self = App._create(path);
  }

  factory App() {
    if(_self == null) throw Exception('The app is not initialezed');
    return _self!;
  }



  String get rootPath => _rootPath;

  TaskCollection get taskCollection {
    if(_taskCollection == null) {
      _taskCollection = TaskCollection('${_rootPath}tasks.json');
      _taskCollection!.load();
    }
    return _taskCollection!;
  }

  GroupCollection get groupCollection {
    if(_groupCollection == null) {
      _groupCollection = GroupCollection('${_rootPath}groups.json');
      _groupCollection!.load();
    }
    return _groupCollection!;
  }

  FutureOr<Response> run(Request request) async {
    final path = request.requestedUri.path.substring(1).split('/');
    try {
        if(path[0] == '') throw HttpNotFoundException();
        if(path.length < 2) path.add('');
        final controller = _controller(path[0], request);
        return await controller.run(path);
    } on HttpException catch(exception) {
        return exception.response;
    }
  }



  AbstractController _controller(String path, Request request) {
    return switch(path) {
      'task' => TaskController(request),
      'group' => GroupController(request),
      _ => throw HttpNotFoundException(),
    };
  }

}