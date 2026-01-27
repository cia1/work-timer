import 'dart:convert';

class Task {

  late String title;
  int seconds = 0; //Колчество секунд до последней остановки
  late DateTime createAt; //Дата и время создания задачи
  DateTime? startAt; //Дата и время последнего запуска или NULL, если таймер выключен
  DateTime? finishAt; //Дата и время последней остановки или NULL, если таймер сейчас работает

  Task(this.title) {
    createAt = DateTime.now();
  }

  Task.fromJson(Map<String, dynamic> json) {
    if(json case {'title': String title}) this.title = title;
    else throw const FormatException('Failed to load task');
    if(json case {'seconds': int seconds}) this.seconds = seconds;
    if(json case {'createAt': int createAt}) this.createAt = DateTime.fromMillisecondsSinceEpoch(createAt * 1000);
    else this.createAt = DateTime.now();
    if(json case {'startAt': int startAt}) this.startAt = DateTime.fromMillisecondsSinceEpoch(startAt * 1000);
    if(json case {'finishAt': int finishAt}) this.finishAt = DateTime.fromMillisecondsSinceEpoch(finishAt * 1000);
  }

  bool get enabled => startAt != null && finishAt == null;

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
    this.seconds = 0;
    if(this.enabled) this.startAt = DateTime.now();
  }

  @override
  String toString() {
    return jsonEncode({
      'title': title,
      'seconds': seconds,
      'createAt': (createAt.millisecondsSinceEpoch / 1000).round(),
      'startAt': startAt == null ? null : (startAt!.millisecondsSinceEpoch / 1000).round(),
      'finishAt': finishAt == null ? null : (finishAt!.millisecondsSinceEpoch / 1000).round()
    });

  }

}