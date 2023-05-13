import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  int id;
  String title;
  String body;

  Note({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
      };

  Note copyWith({
    String? title,
    String? body,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
