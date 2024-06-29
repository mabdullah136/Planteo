// To parse this JSON data, do
//
//     final herbDetailModel = herbDetailModelFromJson(jsonString);

import 'dart:convert';

HerbDetailModel herbDetailModelFromJson(String str) =>
    HerbDetailModel.fromJson(json.decode(str));

String herbDetailModelToJson(HerbDetailModel data) =>
    json.encode(data.toJson());

class HerbDetailModel {
  String status;
  Data data;

  HerbDetailModel({
    required this.status,
    required this.data,
  });

  factory HerbDetailModel.fromJson(Map<String, dynamic> json) =>
      HerbDetailModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String commonName;
  String description;
  String scientificName;
  String optimalSoilPhRange;
  String soilTypePreferences;
  String lightRequirements;
  String waterRequirements;
  String nutrientRequirements;
  String temperatureRange;
  String humidityTolerance;
  String plantingDepthAndSpacing;
  String image;

  Data({
    required this.id,
    required this.commonName,
    required this.description,
    required this.scientificName,
    required this.optimalSoilPhRange,
    required this.soilTypePreferences,
    required this.lightRequirements,
    required this.waterRequirements,
    required this.nutrientRequirements,
    required this.temperatureRange,
    required this.humidityTolerance,
    required this.plantingDepthAndSpacing,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        commonName: json["common_name"],
        description: json["description"],
        scientificName: json["scientific_name"],
        optimalSoilPhRange: json["optimal_soil_ph_range"],
        soilTypePreferences: json["soil_type_preferences"],
        lightRequirements: json["light_requirements"],
        waterRequirements: json["water_requirements"],
        nutrientRequirements: json["nutrient_requirements"],
        temperatureRange: json["temperature_range"],
        humidityTolerance: json["humidity_tolerance"],
        plantingDepthAndSpacing: json["planting_depth_and_spacing"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "common_name": commonName,
        "description": description,
        "scientific_name": scientificName,
        "optimal_soil_ph_range": optimalSoilPhRange,
        "soil_type_preferences": soilTypePreferences,
        "light_requirements": lightRequirements,
        "water_requirements": waterRequirements,
        "nutrient_requirements": nutrientRequirements,
        "temperature_range": temperatureRange,
        "humidity_tolerance": humidityTolerance,
        "planting_depth_and_spacing": plantingDepthAndSpacing,
        "image": image,
      };
}
