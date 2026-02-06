import 'dart:convert';

//Проект
class Project {

  final int id; //Идентификатор проекта (первичный ключ)
  late String title; //Название
  double? rate; //Часовая ставка

  Project(this.id, this.title, [this.rate]);

  factory Project.fromJson(Map<String, dynamic> json) {
    if(json case {
      'id': int id,
      'title': String title,
      'rate': double? rate
      }) {
        return Project(id, title, rate);
    }
    throw const FormatException('Failed to load project');
  }

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'title': title,
      'rate': rate,
    });
  }

}