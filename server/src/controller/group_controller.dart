import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:timer_lib/timer_lib.dart' show Group;
import '../http_exceptions.dart';
import '../group_collection.dart';
import 'abstract_controller.dart';

class GroupController extends AbstractController {

  final GroupCollection _collection;

  GroupController(super.storagePath, super.request): _collection = GroupCollection('${storagePath}groups.json') {
    _collection.load();
  }

  @override
  RouteMap routes() {
    return {
      'GET': list,
      'POST': create,
      'PUT <int>': edit,
      'DELETE <int>': delete
    };
  }

  /// `GET group` Список групп
  Response list() {
    return ok(_collection.toString());
  }

  /// `POST group` Добавление новой группы
  Future<Response> create() async {
    var group = _collection.create(await request.readAsString());
    _collection.save();
    return ok(group);
  }

  /// `PUT group/{id}` Изменение группы
  Future<Response> edit(int index) async {
    var group = _find(index);
    final entity = await requestJson();
    if(entity.containsKey('title')) group.title = entity['title'];
    if(entity.containsKey('rate')) group.rate = entity['rate'];
    _collection.save();
    return ok(group);
  }


  /// `DELETE group/{id}` Удаление группы
  Future<Response> delete(int id) async {
    int? index = _collection.findIndex(id);
    if(index == null) throw HttpNotFoundException('Project not exists');
    _collection.remove(index);
    _collection.save();
    return ok('');
  }

  Group _find(int id) {
    final group = _collection.find(id);
    if(group == null) {
      throw HttpNotFoundException('Requested group not exits');
    }
    return group;
  }

}