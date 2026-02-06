import 'dart:convert';

class Task {

  String title;
  int seconds = 0; //Колчество секунд до последней остановки
  late DateTime createAt; //Дата и время создания задачи
  DateTime? startAt; //Дата и время последнего запуска или NULL, если таймер выключен
  DateTime? finishAt; //Дата и время последней остановки или NULL, если таймер сейчас работает

  Task(this.title) {
    createAt = DateTime.now();
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('seconds')) json['seconds'] = null;
    if(!json.containsKey('createAt')) json['createAt'] = null;
    if(!json.containsKey('startAt')) json['startAt'] = null;
    if(!json.containsKey('finishAt')) json['finishAt'] = null;
    if(json case {
      'title': String title,
      'seconds': int? seconds,
      'createAt': int? createAt,
      'startAt': int? startAt,
      'finishAt': int? finishAt
    }) {
      final task = Task(title);
      if(seconds != null) task.seconds = seconds;
      task.createAt = createAt != null ? DateTime.fromMillisecondsSinceEpoch(createAt * 1000) : DateTime.now();
      if(startAt != null) task.startAt = DateTime.fromMillisecondsSinceEpoch(startAt * 1000);
      if(finishAt != null) task.finishAt = DateTime.fromMillisecondsSinceEpoch(finishAt * 1000);
      return task;
    }
    throw const FormatException('Failed to load task');
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

//Task TaskFromJson(Map<String, dynamic> json) => Task.fromJson(json);