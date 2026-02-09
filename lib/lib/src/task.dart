import 'dart:convert';
import 'package:timer_lib/src/group.dart';

class Task {

  int? group;
  String title;
  int seconds = 0; //Колчество секунд до последней остановки
  DateTime createAt; //Дата и время создания задачи
  DateTime? startAt; //Дата и время последнего запуска или NULL, если таймер выключен
  DateTime? finishAt; //Дата и время последней остановки или NULL, если таймер сейчас работает
  num? rate;

  Task(this.title): createAt = DateTime.now();

  Task.fromJson(Map<String, dynamic> json)
    : group = json['group'],
      title = json['title'],
      rate = json['rate'],
      seconds = json['seconds'] ?? 0,
      createAt = json['createAt'] == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(json['createAt'] * 1000),
      startAt = json['startAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['startAt'] * 1000),
      finishAt = json['finishAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['finishAt'] * 1000);



  bool get enabled => startAt != null && finishAt == null;

  void setGroup(Group group) {
    this.group = group.id;
    rate = group.rate;
  }

  void start() {
    startAt = DateTime.now();
    finishAt = null;
  }

  void stop() {
    final DateTime date = DateTime.now();
    finishAt = date;
    seconds += date.difference(startAt!).inSeconds;
    startAt = null;
  }

  void increaseTime(int seconds) {
    this.seconds += seconds;
  }

  void decreaseTime(int seconds) {
    if(seconds > this.seconds) this.seconds = 0;
    else this.seconds -= seconds;
  }

  void reset() {
    seconds = 0;
    if(enabled) startAt = DateTime.now();
  }

  @override
  String toString() {
    return jsonEncode({
      'group': group,
      'title': title,
      'rate': rate,
      'seconds': seconds,
      'createAt': (createAt.millisecondsSinceEpoch / 1000).round(),
      'startAt': startAt == null ? null : (startAt!.millisecondsSinceEpoch / 1000).round(),
      'finishAt': finishAt == null ? null : (finishAt!.millisecondsSinceEpoch / 1000).round()
    });

  }

}