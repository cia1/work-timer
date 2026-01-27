import 'widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'repository.dart';
import 'widget/task_row.dart';
import 'widget/totals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(await FlutterSingleInstance().isFirstInstance()) {
    runApp(const MyApp());
  } else {
    FlutterSingleInstance().focus();
  }
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const String title = 'Tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(),
      body: _TasksList()
    );
  }

}



const duration = Duration(seconds: 2);

class _TasksList extends StatefulWidget {

  @override
  State<_TasksList> createState() => _TasksListState();

}

class _TasksListState extends State<_TasksList> {

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final repository = Repository();
    repository.onChange = _refresh;
    return Padding(
      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
      child: ListView.builder(
        itemCount: repository.length + 1,
        itemBuilder: (context, index) {
          if(repository.length > 0 && repository.length > index) {
            return TaskRow(index);
          } else {
            return Totals(repository);
          }
        },
      )
    );
  }

}