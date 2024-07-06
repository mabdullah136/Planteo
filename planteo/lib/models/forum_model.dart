import 'dart:convert';

// To parse this JSON data, do
//     final plantModel = plantModelFromJson(jsonString);

List<ForumModel> forumModelFromJson(String str) =>
    List<ForumModel>.from(json.decode(str).map((x) => ForumModel.fromJson(x)));

String forumModelToJson(List<ForumModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumModel {
  int id;
  String? image;
  DateTime uploadDate;
  String subject;
  String? description;
  int user;

  ForumModel({
    required this.id,
    required this.image,
    required this.uploadDate,
    required this.subject,
    this.description,
    required this.user,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) => ForumModel(
        id: json["id"],
        image: json["image"] ?? 'https://via.placeholder.com/150',
        uploadDate: DateTime.parse(json["upload_date"]),
        subject: json["subject"],
        description: json["description"] ?? '',
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "upload_date": uploadDate.toIso8601String(),
        "subject": subject,
        "description": description,
        "user": user,
      };
}
