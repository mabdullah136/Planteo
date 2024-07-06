// To parse this JSON data, do
//
//     final gardenDetail = gardenDetailFromJson(jsonString);

import 'dart:convert';

List<GardenDetail> gardenDetailFromJson(String str) => List<GardenDetail>.from(
    json.decode(str).map((x) => GardenDetail.fromJson(x)));

String gardenDetailToJson(List<GardenDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GardenDetail {
  int id;
  int rowNo;
  int columnNo;
  String plantName;
  String? icons;
  int garden;
  int herb;

  GardenDetail({
    required this.id,
    required this.rowNo,
    required this.columnNo,
    required this.plantName,
    required this.icons,
    required this.garden,
    required this.herb,
  });

  factory GardenDetail.fromJson(Map<String, dynamic> json) => GardenDetail(
        id: json["id"],
        rowNo: json["row_no"],
        columnNo: json["column_no"],
        plantName: json["plant_name"],
        icons: json["icons"],
        garden: json["garden"],
        herb: json["herb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "row_no": rowNo,
        "column_no": columnNo,
        "plant_name": plantName,
        "icons": icons,
        "garden": garden,
        "herb": herb,
      };
}
