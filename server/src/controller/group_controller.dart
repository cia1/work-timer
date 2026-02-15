import 'dart:async';
import 'package:shelf/shelf.dart';
import '../app.dart';
import '../entities/group_collection.dart';
import '../entities/group_factory.dart';
import '../http_exceptions.dart';
import 'abstract_controller.dart';

class GroupController extends AbstractController<GroupFactory> {

  final GroupCollection _collection;

  GroupController(super.request): _collection = App().groupCollection;

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
    final factory = await validatedFactory(true);
    final group = factory.make();
    _collection.add(group);
    _collection.save();
    return ok(group);
  }

  /// `PUT group/{id}` Изменение группы
  Future<Response> edit(int id) async {
    final group = _collection.find(id);
    if(group == null) throw HttpNotFoundException('The group not exists');
    final factory = await validatedFactory(false);
    factory.fill(group);
    _collection.save();
    return ok(group);
  }

  /// `DELETE group/{id}` Удаление группы
  Future<Response> delete(int id) async {
    if(!_collection.delete(id)) {
      throw HttpNotFoundException('the group not exists');
    }
    App().taskCollection.unsetGroup(id);
    _collection.save();
    return ok('');
  }



  @override
  GroupFactory Function(String raw) factoryGenerator() => GroupFactory.fromString;

}