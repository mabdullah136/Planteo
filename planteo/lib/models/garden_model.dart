// To parse this JSON data, do
//
//     final garden = gardenFromJson(jsonString);

import 'dart:convert';

List<Garden> gardenFromJson(String str) =>
    List<Garden>.from(json.decode(str).map((x) => Garden.fromJson(x)));

String gardenToJson(List<Garden> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Garden {
  int id;
  String name;
  String length;
  String width;

  Garden({
    required this.id,
    required this.name,
    required this.length,
    required this.width,
  });

  factory Garden.fromJson(Map<String, dynamic> json) => Garden(
        id: json["id"],
        name: json["name"],
        length: json["length"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "length": length,
        "width": width,
      };
}
