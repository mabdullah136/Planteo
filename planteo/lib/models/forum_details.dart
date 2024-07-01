// To parse this JSON data, do
//
//     final forumDetail = forumDetailFromJson(jsonString);

import 'dart:convert';

ForumDetail forumDetailFromJson(String str) =>
    ForumDetail.fromJson(json.decode(str));

String forumDetailToJson(ForumDetail data) => json.encode(data.toJson());

class ForumDetail {
  String firstName;
  String lastName;
  QueryDetail queryDetail;
  List<Feedback> feedback;

  ForumDetail({
    required this.firstName,
    required this.lastName,
    required this.queryDetail,
    required this.feedback,
  });

  factory ForumDetail.fromJson(Map<String, dynamic> json) => ForumDetail(
        firstName: json["first_name"],
        lastName: json["last_name"],
        queryDetail: QueryDetail.fromJson(json["query_detail"]),
        feedback: List<Feedback>.from(
            json["feedback"].map((x) => Feedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "query_detail": queryDetail.toJson(),
        "feedback": List<dynamic>.from(feedback.map((x) => x.toJson())),
      };
}

class Feedback {
  int id;
  String feedbackText;
  int totalVotes;

  Feedback({
    required this.id,
    required this.feedbackText,
    required this.totalVotes,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json["id"],
        feedbackText: json["feedback_text"],
        totalVotes: json["total_votes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feedback_text": feedbackText,
        "total_votes": totalVotes,
      };
}

class QueryDetail {
  String image;
  String subject;
  String description;
  String uploadDate;

  QueryDetail({
    required this.image,
    required this.subject,
    required this.description,
    required this.uploadDate,
  });

  factory QueryDetail.fromJson(Map<String, dynamic> json) => QueryDetail(
        image: json["image"],
        subject: json["subject"],
        description: json["description"],
        uploadDate: json["upload_date"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "subject": subject,
        "description": description,
        "upload_date": uploadDate,
      };
}
