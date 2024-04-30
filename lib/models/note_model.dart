import 'dart:convert';

NoteModel noteFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
  int id;
  String title;
  String body;
  String? date;

  NoteModel({
    required this.id,
    this.title = '',
    this.body = '',
    this.date,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
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

  NoteModel copyWith({
    String? title,
    String? body,
    String? date,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }
}
