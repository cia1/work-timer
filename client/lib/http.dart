import 'dart:async';
import 'package:http/http.dart' as http;



const _host = 'http://djusti.ru';
const _port = 8005;

Future<String> get(String path) async {
  final response = await http.get(_uri(path));
  if (response.statusCode != 200) throw Exception('Connection failed');
  return response.body;
}

void post(String path, String json) async {
  http.post(
    _uri(path),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
}

void put(String path, [Object? content]) {
  http.put(_uri(path), body: content);
}

void delete(String path) {
  http.delete(_uri(path));
}



Uri _uri(String path) => Uri.parse('$_host:$_port/$path');