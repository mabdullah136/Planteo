// // To parse this JSON data, do
// //
// //     final herbsModel = herbsModelFromJson(jsonString);

// import 'dart:convert';

// // HerbsModel herbsModelFromJson(String str) =>
// //     HerbsModel.fromJson(json.decode(str));

// // List<HerbsModel> herbsModelFromJson(String str) =>
// //     List<HerbsModel>.from(json.decode(str).map((x) => HerbsModel.fromJson(x)));
// List<HerbsModel> herbsModelFromJson(String str) =>
//     List<HerbsModel>.from(json.decode(str).map((x) => HerbsModel.fromJson(x)));

// String herbsModelToJson(List<HerbsModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // String herbsModelToJson(HerbsModel data) => json.encode(data.toJson());

// class HerbsModel {
//   String status;
//   List<Datum> data;

//   HerbsModel({
//     required this.status,
//     required this.data,
//   });

//   factory HerbsModel.fromJson(Map<String, dynamic> json) => HerbsModel(
//         status: json["status"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   int id;
//   // String commonName;
//   // String description;
//   // String image;

//   Datum({
//     required this.id,
//     // required this.commonName,
//     // required this.description,
//     // required this.image,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         // commonName: json["common_name"],
//         // description: json["description"],
//         // image: json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         // "common_name": commonName,
//         // "description": description,
//         // "image": image,
//       };
// }
import 'dart:convert';

HerbsModel herbsModelFromJson(String str) {
  final jsonData = json.decode(str);
  return HerbsModel.fromJson(jsonData);
}

String herbsModelToJson(HerbsModel data) {
  return json.encode(data.toJson());
}

class HerbsModel {
  String status;
  List<Datum> data;

  HerbsModel({
    required this.status,
    required this.data,
  });

  factory HerbsModel.fromJson(Map<String, dynamic> json) => HerbsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String commonName;
  String description;
  String image;

  Datum({
    required this.id,
    required this.commonName,
    required this.description,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        commonName: json["common_name"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "common_name": commonName,
        "description": description,
        "image": image,
      };
}
