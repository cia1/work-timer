import 'dart:convert';

//Проект
class Group {

  final int id; //Идентификатор проекта (первичный ключ)
  String title; //Название
  num? rate; //Часовая ставка

  Group(this.id, this.title, [this.rate]);
  Group.fromJson(Map<String, dynamic> json): this(json['id'], json['title'], json['rate']);

  @override
  String toString() => jsonEncode({'id': id, 'title': title, 'rate': rate});

}