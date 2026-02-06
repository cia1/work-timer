import 'dart:async';
import 'dart:convert';
import 'package:timer_lib/timer_lib.dart' as lib;
import 'task.dart';
import 'http.dart' as http;

class Repository extends lib.Collection<Task> {

  Timer? _timer;

  static final Repository _repository = Repository._internal();

  factory Repository() {
    return _repository;
  }
  Repository._internal(): super(Task.fromJson);

  Function? _setState;
  set onChange(void Function() callback) {
    _setState = callback;
  }

  Future<List<Task>> fetch() async {
    final json = http.get('');
    if(json is! List) throw Exception('Bad server response');
    for(dynamic task in json as List) {
      super.add(Task.fromJson(task));
    }
    refresh();
    return entities;
  }

  @override
  Task get(int index) => super.get(index) as Task;

  @override
  void add(Task task) {
    super.add(task);
    _post('', task.toString());
    refresh();
  }

  @override
  void remove(int index) {
    super.remove(index);
    _delete('$index');
    refresh();
  }

  void start(Task task) {
    task.start();
    final index = _index(task);
    _put('$index/toggle');
    refresh();
  }

  void stop(Task task) {
    task.stop();
    final index = _index(task);
    _put('$index/toggle');
    refresh();
  }

    void increaseTime(Task task, int seconds) {
        task.increaseTime(seconds);
        final index = _index(task);
        _put('$index/increase-time', seconds.toString());
        refresh();
    }

    void decreaseTime(Task task, int seconds) {
        task.decreaseTime(seconds);
        final index = _index(task);
        _put('$index/decrease-time', seconds.toString());
        refresh();
    }

    void reset(Task task) {
        task.reset();
        final index = _index(task);
        _put('$index/reset');
        refresh();
    }

  void rename(Task task, String value) {
    task.title = value;
    final index = _index(task);
    _put('$index', value);
    refresh();
  }

  void refresh() {
    if(entities.any((task) => task.enabled)) _startTimer(); else _stopTimer();
    _refresh();
  }

  String total() {
    int seconds = entities.fold(0, (int duration, Task task) => duration + task.fullSeconds);
    var duration = Duration(seconds: seconds);
    String hours = (seconds / 3600).toStringAsFixed(2);
    if (hours.endsWith('0')) {
      hours = hours.substring(0, hours.length - 1);
      if (hours.endsWith('0')) {
        hours = hours.substring(0, hours.length - 2);
      }
    }
    return '${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')} ($hours h)';
  }

  void _refresh() {
    if(_setState != null) _setState!();
  }

  void _startTimer() {
    if(_timer != null) return;
    _timer = Timer.periodic(_duration, (timer) => _refresh());
  }

  void _stopTimer() {
    Timer? timer = _timer;
    if(timer != null) {
      timer.cancel();
      _timer = null;
    }
  }

  int _index(Task task) {
    return entities.indexOf(task);
  }

}