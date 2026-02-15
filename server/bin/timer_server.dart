import 'package:shelf/shelf_io.dart' as shelf_io;
import '../src/app.dart';

void main(List<String> arguments) async {
  if(_isHelp(arguments)) _printHelp();
  else _startServer(_host(arguments), _port(arguments), _db(arguments));
}



bool _isHelp(List<String> arguments) {
  for(String argument in arguments) {
    final parts = argument.split('=');
    if(parts[0] == '-h' || parts[0] == '?' || parts[0] == '-help' || parts[0] == '--help') return true;
  }
  return false;
}

String _host(List<String> arguments) {
  for(String argument in arguments) {
    final parts = argument.split('=');
    if(parts[0] == '--host') return parts[1];
  }
  return '0.0.0.0';
}

int _port(List<String> arguments) {
  for(String argument in arguments) {
    final parts = argument.split('=');
    if(parts[0] == '-p' || parts[0] == '-port' || parts[0] == '--port') return int.parse(parts[1]);
  }
  return 8080;
}

String _db(List<String> arguments) {
  for(String argument in arguments) {
    final parts = argument.split('=');
    if(parts[0] == '-db' || parts[0] == '--db') return parts[1];
  }
  return './';
}

void _printHelp() {
  print('Starts timer server. Command line: timer-server.exe [PARAMETERS]');
  print('Parameters:');
  print('-h, -?, --help      \tThis help screen.');
  print('-p, --port =XXXX    \tPort number, default is 8080.');
  print('--host=XXXX         \tHost, default is "0.0.0.0" (receive at any IP)');
  print('-db, --db =XXXX.XXXX\tJob`s database file name, default is "jobs.json".');
}

void _startServer(String host, int port, String path) async {
  final app = App.create(path);
  var server = await shelf_io.serve(app.run, host, port);
  print('Listen http://${server.address.host}:${server.port}');
}