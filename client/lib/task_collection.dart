import 'dart:async';
import 'package:timer_lib/timer_lib.dart' as lib;
import 'task.dart';
import 'http.dart' as http;

const Duration _duration = Duration(seconds: 1);

class TaskCollection extends lib.Collection<Task> {

  Timer? _timer;

  static final TaskCollection _self = TaskCollection._internal();
  factory TaskCollection() => _self;
  TaskCollection._internal(): super(Task.create);

  Function? _setState;
  set onChange(void Function() callback) {
    _setState = callback;
  }

  Future<List<Task>> fetch() async {
    fromString(await http.get('task'));
    refresh();
    return entities;
  }

  void create(Task task) {
    super.add(task);
    http.post('task', task.toString());
    refresh();
  }

  void rename(Task task, String value) {
    task.title = value;
    final index = _index(task);
    http.put('task/$index', value);
    refresh();
  }

  void start(Task task) {
    task.start();
    final index = _index(task);
    http.put('task/$index/toggle');
    refresh();
  }

  void stop(Task task) {
    task.stop();
    final index = _index(task);
    http.put('task/$index/toggle');
    refresh();
  }

  void increaseTime(Task task, int seconds) {
    task.increaseTime(seconds);
    final index = _index(task);
    http.put('task/$index/increase-time', seconds.toString());
    refresh();
  }

  void decreaseTime(Task task, int seconds) {
    task.decreaseTime(seconds);
    final index = _index(task);
    http.put('task/$index/decrease-time', seconds.toString());
    refresh();
  }

  void reset(Task task) {
    task.reset();
    final index = _index(task);
    http.put('task/$index/reset');
    refresh();
  }

  @override
  void remove(int index) {
    super.remove(index);
    http.delete('task/$index');
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