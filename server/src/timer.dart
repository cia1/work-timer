import 'collection.dart';
import 'package:timer_lib/timer_lib.dart' show Task;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Timer {

  Collection collection;

  Timer(String fileName): collection = Collection(fileName) {
    collection.load();
  }

  ///Список задач
  Response list(Request _) {
    return _ok(collection.toString());
  }

  /// `POST /` Добавление новой задачи
  Future<Response> add(Request request) async {
    var task = collection.create(await request.readAsString());
    collection.save();
    return _ok(task);
  }

  /// `PUT {index}` Переименование задачи
  Future<Response> rename(Request request, String index) async {
    var title = await request.readAsString();
    if(title == '') return Response.badRequest(body: 'Title required');
    var task = collection.get(int.parse(index));
    task.title = title;
    collection.save();
    return _ok(task);
  }

  /// `PUT {index}/toggle` Запуск или остановка задачи
  Future<Response> toggle(Request _, String id) async {
    var task = collection.get(int.parse(id));
    if(task.enabled) task.stop();
    else task.start();
    collection.save();
    return _ok(task);
  }

  /// `DELETE {index}` Удаление задачи
  Future<Response> delete(Request _, String index) async {
    collection.remove(int.parse(index));
    return _ok('');
  }

  /// `PUT {index}/increase-time` Добавление времени к задаче
  Future<Response> increaseTime(Request request, String index) async {
    final Task task = collection.get(int.parse(index));
    var seconds = await request.readAsString();
    task.increaseTime(int.parse(seconds));
    collection.save();
    return _ok(task);
  }

  /// `PUT {index}/increase-time` Добавление времени к задаче
  Future<Response> decreaseTime(Request request, String index) async {
    final Task task = collection.get(int.parse(index));
    var seconds = await request.readAsString();
    task.decreaseTime(int.parse(seconds));
    collection.save();
    return _ok(task);
  }

  Future<Response> reset(Request _, String index) async {
    final Task task = collection.get(int.parse(index));
    task.reset();
    collection.save();
    return _ok(task);
  }

  Handler get handler {
    final router = Router();
    router.add('GET', '/', list);
    router.add('POST', '/', add);
    router.add('PUT', r'/<index>', rename);
    router.add('PUT', r'/<index>/toggle', toggle);
    router.add('PUT', r'/<index>/increase-time', increaseTime);
    router.add('PUT', r'/<index>/decrease-time', decreaseTime);
    router.add('PUT', r'/<index>/reset', reset);
    router.add('DELETE', r'/<index>', delete);
    return router.call;
  }

  Response _ok(Object response) => Response.ok(response.toString(), headers: {'Content-Type': 'application/json'});

}