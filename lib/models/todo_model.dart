import 'dart:convert';

TodoModel todoFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  int id;
  String title;
  bool isComplete;
  String? date;

  TodoModel({
    required this.id,
    required this.title,
    this.isComplete = false,
    this.date,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
        isComplete: json["completed"] == 1 ? true : false,
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "completed": isComplete ? 1 : 0,
        "date": date,
      };

  TodoModel copyWith({
    String? title,
    bool? isComplete,
    String? date,
  }) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      date: date ?? this.date,
    );
  }
}
