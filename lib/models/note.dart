import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  int id;
  String? title;
  String body;
  String? date;

  Note({
    required this.id,
    this.title,
    required this.body,
    this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "date": date,
      };

  Note copyWith({
    String? title,
    String? body,
    String? date,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }
}
