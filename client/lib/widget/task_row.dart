import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_client/task.dart';
import '../task_collection.dart';

final style = ElevatedButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
  minimumSize: Size(1,1)
);
const enabledTextStyle = TextStyle(color: Colors.blue);
const disabledTextStyle = TextStyle(color: Colors.grey);

class TaskRow extends StatelessWidget {

  const TaskRow(this._index, {super.key});

  final int _index;

  @override
  Widget build(BuildContext context) {
    final task = TaskCollection().get(_index);
    return Padding(
      padding: EdgeInsets.all(5),
      child: LayoutBuilder(builder: (builder, constrains) {
        final wide = constrains.maxWidth > 650;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            if(wide) ElevatedButton(
              style: style,
              onPressed: () => TaskCollection().remove(_index),
              child: Text('X'),
            ),
            Expanded(child: TextButton(
              style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              onPressed: () => _rename(context, task),
              child: Text(task.title, style: task.enabled ? enabledTextStyle : disabledTextStyle)
            )),
            Text(task.dateRange, style: task.enabled ? enabledTextStyle : disabledTextStyle),
            Text(task.time, style: task.enabled ? enabledTextStyle : disabledTextStyle),
            if(wide && task.enabled) ElevatedButton(
                style: style,
                onPressed: () => _stop(task),
                child: Text('Stop'),
            )
            else if(wide) ElevatedButton(
                style: style,
                onPressed: () => _start(task),
                child: Text('Start'),
            ),
            if(wide) ElevatedButton(
              style: style,
              onPressed: () => _decreaseTime(context, task),
              child: Text('-'),
            ),
            if(wide) ElevatedButton(
              style: style,
              onPressed: () => _increaseTime(context, task),
              child: Text('+'),
            ),
            if(wide) ElevatedButton(
              style: style,
              onPressed: () => _reset(task),
              child: Text('Reset')
            ),

            if(!wide) MenuAnchor(
              builder: (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                  icon: const Icon(Icons.more_horiz)
                );
              },
              menuChildren: [
                if(task.enabled) MenuItemButton(
                  onPressed: () => _stop(task),
                  child: Text('Stop')
                )
                else MenuItemButton(
                  onPressed: () => _start(task),
                  child: Text('Start'),
                ),
                MenuItemButton(
                  onPressed: () => _decreaseTime(context, task),
                  child: Text('Time -'),
                ),
                MenuItemButton(
                  onPressed: () => _increaseTime(context, task),
                  child: Text('Time +'),
                ),
                MenuItemButton(
                  onPressed: () => _reset(task),
                  child: Text('Time reset')
                ),
                MenuItemButton(
                  onPressed: () => TaskCollection().remove(_index),
                  child: Text('Delete')
                )
              ]
            )
          ],
        );
      }), 
    );
  }

    void _start(Task task) {
      TaskCollection().start(task);
    }
    void _stop(Task task) {
      TaskCollection().stop(task);
    }
    void _rename(BuildContext context, Task task) async {
        String? value = await _textDialog(context, 'Rename', 'Title:', task.title);
        if(value != null) TaskCollection().rename(task, value);
    }
    void _increaseTime(BuildContext context, Task task) async {
        String? value = await _textDialog(context, 'Increase time', 'Time (munutes):');
        if(value != null) TaskCollection().increaseTime(task, int.parse(value) * 60);
    }
    void _decreaseTime(BuildContext context, Task task) async {
        String? value = await _textDialog(context, 'Decrease time', 'Time (minutes):');
        if(value != null) TaskCollection().decreaseTime(task, int.parse(value) * 60);
    }
    void _reset(Task task) {
        TaskCollection().reset(task);
    }

  Future<String?> _textDialog(BuildContext context, String title, String label, [String value = '']) {
    final completer = Completer<String?>();
    void complete(String value) {
        Navigator.pop(context);
        completer.complete(value.isEmpty ? null : value);
    }
    final controller = TextEditingController(text: value);
    controller.selection = TextSelection(baseOffset: 0, extentOffset: value.length);
    showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            selectAllOnFocus: true,
            decoration: InputDecoration(hintText: label),
            controller: controller,
            autofocus: true,
            onSubmitted: complete
          ),
          actions: <Widget>[
            FloatingActionButton(
              onPressed: () => complete(controller.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return completer.future;
  }

}