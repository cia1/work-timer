import 'package:flutter/material.dart';
import '../task_collection.dart';
import '../task.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Active tasks:"),
      backgroundColor: Colors.cyan,
      actions: [
        FloatingActionButton(
          onPressed: () =>_addTaskDialog(context),
          child: Text("+")
        )
      ],
      actionsPadding: EdgeInsets.all(5),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> _addTaskDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New task'),
          content: TextField(
            decoration: InputDecoration(hintText: "Name"),
            controller: controller,
            autofocus: true,
            onSubmitted: (String value) => _addTaskFinish(context, value)
          ),
          actions: <Widget>[
            FloatingActionButton(onPressed: () => _addTaskFinish(context, controller.text), child: Text('Add'))
          ]
        );

      }
    );
  }

  void _addTaskFinish(BuildContext context, String value) {
    Navigator.pop(context);
    if(value.isEmpty) return;
    TaskCollection().create(Task(value));
  }

}