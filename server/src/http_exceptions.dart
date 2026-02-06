import 'package:shelf/shelf.dart';

abstract class HttpException {

    final int code;
    final String message;

    HttpException(this.code, this.message);

    Response get response {
      return Response(code, body: message, headers: {'Content-Type': 'application/json'});
    }

}

class HttpNotFoundException extends HttpException {

  HttpNotFoundException([String message = 'Page not found']): super(404, message);

}