import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';
import '../http_exceptions.dart';

typedef RouteMap = Map<String, Function>;

abstract class AbstractController {

  AbstractController(String storagePath);

  @protected
  RouteMap routes();

  FutureOr<Response> run(List<String> requestPath, Request request) {
    for(final entity in routes().entries) {
      final route = _parse(entity.key);
      if(route.method != request.method) continue;
      if(route.path.length != requestPath.length - 1) continue;
      bool isMath = true;
      List<Object> attributes = [request];
      for(int i = 0; i < route.path.length; i++) {
        if(route.path[i] == requestPath[i + 1]) continue;
        if(route.path[i] == '<int>') {
          int? argument = int.tryParse(requestPath[i + 1]);
          if(argument == null) {
            isMath = false;
            break;
          }
          attributes.add(argument);
        } else {
          isMath = false;
          break;
        }
      }
      if(isMath) return Function.apply(entity.value, attributes);
    }
    throw HttpNotFoundException();
  }



  @protected
  Response ok(Object response) => Response.ok(
    response.toString(),
    headers: {'Content-Type': 'application/json'},
  );

  ({String method, List<String> path}) _parse(String route) {
    final tmp = route.split(' ');
    if(tmp.length < 2) tmp.add('');
    final path = tmp[1].split('/');
    return (method: tmp[0], path: path);
  } 

}