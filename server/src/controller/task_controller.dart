import 'dart:async';
import 'package:shelf/shelf.dart';
import '../http_exceptions.dart';
import '../task_collection.dart';
import 'package:timer_lib/timer_lib.dart' show Task;
import 'abstract_controller.dart';

class TaskController extends AbstractController {

  final TaskCollection _collection;

  TaskController(super.storagePath): _collection = TaskCollection('${storagePath}tasks.json') {
    _collection.load();
  }

  @override
  RouteMap routes() {
    return {
      'GET': list,
      'POST': create,
      'PUT <int>': rename,
      'PUT <int>/toggle': toggle,
      'PUT <int>/increase-time': increaseTime,
      'PUT <int>/decrease-time': decreaseTime,
      'PUT <int>/reset': reset,
      'DELETE <int>': delete
    };
  }

  /// `GET task` Список задач
  Response list(Request _) {
    return ok(_collection.toString());
  }

  /// `POST /` Добавление новой задачи
  Future<Response> create(Request request) async {
    var task = _collection.create(await request.readAsString());
    _collection.save();
    return ok(task);
  }

  /// `PUT {index}` Переименование задачи
  Future<Response> rename(Request request, int index) async {
    var title = await request.readAsString();
    if (title == '') return Response.badRequest(body: 'Title required');
    var task = _collection.get(index);
    task.title = title;
    _collection.save();
    return ok(task);
  }

  /// `PUT {index}/toggle` Запуск или остановка задачи
  Future<Response> toggle(Request _, int index) async {
    var task = _collection.get(index);
    if(task.enabled) task.stop();
    else task.start();
    _collection.save();
    return ok(task);
  }

  /// `PUT {index}/increase-time` Добавление времени к задаче
  Future<Response> increaseTime(Request request, int index) async {
    final Task task = _collection.get(index);
    var seconds = await request.readAsString();
    task.increaseTime(int.parse(seconds));
    _collection.save();
    return ok(task);
  }

  /// `PUT {index}/increase-time` Добавление времени к задаче
  Future<Response> decreaseTime(Request request, int index) async {
    final Task task = _collection.get(index);
    var seconds = await request.readAsString();
    task.decreaseTime(int.parse(seconds));
    _collection.save();
    return ok(task);
  }

  /// `PUT {index}/reset` Сброс счётчика времени
  Future<Response> reset(Request _, int index) async {
    final Task task = _collection.get(index);
    task.reset();
    _collection.save();
    return ok(task);
  }

  /// `DELETE {index}` Удаление задачи
  Future<Response> delete(Request _, int index) async {
    if(_collection.entities.length <= index) throw HttpNotFoundException('Task not exists');
    _collection.remove(index);
    _collection.save();
    return ok('');
  }

}