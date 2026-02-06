import 'dart:async';
import 'package:shelf/shelf.dart';
import 'controller/abstract_controller.dart';
import 'controller/task_controller.dart';
import 'http_exceptions.dart';

class Timer {

  late final String rootPath;

  Timer(String path) {
    if(!path.endsWith('/')) path = '$path/';
    rootPath = path;
  }

  FutureOr<Response> handler(Request request) async {
    final path = request.requestedUri.path.substring(1).split('/');
    try {
        if(path[0] == '') throw HttpNotFoundException();
        if(path.length < 2) path.add('');
        final controller = _controller(path[0]);
        return await controller.run(path, request);
    } on HttpException catch(exception) {
        return exception.response;
    }
  }



  AbstractController _controller(String path) {
    return switch(path) {
      'task' => TaskController(rootPath),
      //'project' => ProjectController(),
      _ => throw HttpNotFoundException(),
    };
  }

}