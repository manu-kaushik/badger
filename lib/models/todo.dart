import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  int id;
  String title;
  String? description;
  bool completed;
  String? color;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.color,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        completed: json["completed"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "completed": completed,
        "color": color,
      };

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
    String? color,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      color: color ?? this.color,
    );
  }
}
