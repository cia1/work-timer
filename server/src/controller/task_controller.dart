import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:timer_lib/timer_lib.dart' show Task;
import '../app.dart';
import '../http_exceptions.dart';
import '../entities/task_collection.dart';
import '../entities/task_factory.dart';
import 'abstract_controller.dart';

class TaskController extends AbstractController<TaskFactory> {

  final TaskCollection _collection;

  TaskController(super.request): _collection = App().taskCollection;

  @override
  RouteMap routes() {
    return {
      'GET': list,
      'POST': create,
      'PUT <int>': edit,
      'PUT <int>/toggle': toggle,
      'PUT <int>/increase-time': increaseTime,
      'PUT <int>/decrease-time': decreaseTime,
      'PUT <int>/reset': reset,
      'DELETE <int>': delete
    };
  }

  /// `GET task` Список задач
  Response list() {
    return ok(_collection.toString());
  }

  /// `POST task` Добавление новой задачи
  Future<Response> create() async {
    final factory = await validatedFactory(true);
    final task = factory.make();
    _collection.add(task);
    _collection.save();
    return ok(task);
  }

  /// `PUT task/{index}` Изменение задачи
  Future<Response> edit(int index) async {
    final task = _findOrThrow(index);
    final factory = await validatedFactory(false);
    factory.fill(task);
    _collection.save();
    return ok(task);
  }

  /// `PUT task/{index}/toggle` Запуск или остановка задачи
  Future<Response> toggle(int index) async {
    final task = _findOrThrow(index);
    if(task.enabled) task.stop();
    else task.start();
    _collection.save();
    return ok(task);
  }

  /// `PUT task/{index}/increase-time` Добавление времени к задаче
  Future<Response> increaseTime(int index) async {
    final task = _findOrThrow(index);
    var seconds = await request.readAsString();
    task.increaseTime(int.parse(seconds));
    _collection.save();
    return ok(task);
  }

  /// `PUT task/{index}/increase-time` Добавление времени к задаче
  Future<Response> decreaseTime(int index) async {
    final task = _findOrThrow(index);
    var seconds = await request.readAsString();
    task.decreaseTime(int.parse(seconds));
    _collection.save();
    return ok(task);
  }

  /// `PUT task/{index}/reset` Сброс счётчика времени
  Future<Response> reset(int index) async {
    final task = _findOrThrow(index);
    task.reset();
    _collection.save();
    return ok(task);
  }

  /// `DELETE task/{index}` Удаление задачи
  Future<Response> delete(int index) async {
    if(!_collection.remove(index)) throw HttpNotFoundException('Task not exists');
    _collection.save();
    return ok('');
  }



  @override
  TaskFactory Function(String raw) factoryGenerator() => TaskFactory.fromString;



  Task _findOrThrow(int index) {
    final task = _collection.get(index);
    if(task == null) throw HttpNotFoundException('The task not found');
    return task;
  }

}