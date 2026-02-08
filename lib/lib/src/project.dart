import 'dart:convert';

//Проект
class Project {

  final int id; //Идентификатор проекта (первичный ключ)
  late String title; //Название
  double? rate; //Часовая ставка

  Project(this.id, this.title, [this.rate]);

  static Map<String, dynamic> parse(Map<String, dynamic> json) {
    if(!json.containsKey('rate')) json['rate'] = null;
    if(json case {
      'id': int _,
      'title': String _,
      'rate': double? _
      }) {
        return json;
    }
    throw const FormatException('Failed to load project');
  }

  factory Project.create(Map<String, dynamic> json) {
    return Project.fromJson(parse(json));
  }
  Project.fromJson(Map<String, dynamic> json): this(json['id'], json['title'], json['rate']);

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'title': title,
      'rate': rate,
    });
  }

}