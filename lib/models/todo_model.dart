import 'dart:convert';

TodoModel todoFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  int id;
  String title;
  String? description;
  bool completed;
  String? color;
  String? date;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.color,
    this.date,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        completed: json["completed"] == 1 ? true : false,
        color: json["color"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "completed": completed ? 1 : 0,
        "color": color,
        "date": date,
      };

  TodoModel copyWith({
    String? title,
    String? description,
    bool? completed,
    String? color,
    String? date,
  }) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      color: color ?? this.color,
      date: date ?? this.date,
    );
  }
}
