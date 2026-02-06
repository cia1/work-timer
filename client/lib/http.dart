import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



const _host = 'http://djusti.ru';
const _port = 8005;
const Duration _duration = Duration(seconds: 1);

Future<List> getList(String path) async {
  final response = await _get(path);
  

}







Uri _uri(String path) => Uri.parse('$_host:$_port/$path');

Future<Object> _get(String path) async {
  final response = await http.get(_uri(path));
  if (response.statusCode != 200) throw Exception('Connection failed');
  return jsonDecode(response.body);
}

void _post(String path, String json) {
  http.post(
    _uri(path),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
}

void _put(String path, [Object? content]) {
  http.put(_uri(path), body: content);
}

void _delete(String path) {
  http.delete(_uri(path));
}


