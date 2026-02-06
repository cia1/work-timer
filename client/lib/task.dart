import 'package:intl/intl.dart';
import 'package:timer_lib/timer_lib.dart' as lib;

class Task extends lib.Task {

  @override
  factory Task.fromJson(Map<String, dynamic> json) => lib.Task.fromJson(json) as Task;

  Task(super.title);

  String get dateRange {
    final format = DateFormat.yMd();
    final createAt = format.format(this.createAt);

    DateTime? date = this.startAt ?? this.finishAt;
    if(date == null) return createAt;
    final date2 = format.format(date);
    if(createAt == date2) return createAt;
    return "$createAt\n$date2";
  }

  int get fullSeconds {
    DateTime? startAt = this.startAt;
    int seconds = this.seconds;
    if(startAt != null) seconds += DateTime.now().difference(startAt).inSeconds;
    return seconds;
  }

  String get time {
    final seconds = fullSeconds;
    var duration = Duration(seconds: seconds);
    String hours = (seconds / 3600).toStringAsFixed(2);
    if(hours.endsWith('0')) {
      hours = hours.substring(0, hours.length - 1);
      if(hours.endsWith('0')) {
        hours = hours.substring(0, hours.length - 2);
      }
    }
    return '${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}\n($hours h)';
  }

}