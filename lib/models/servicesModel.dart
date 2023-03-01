// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

List<ServicesModel> servicesModelFromJson(String str) =>
    List<ServicesModel>.from(
        json.decode(str).map((x) => ServicesModel.fromJson(x)));

String servicesModelToJson(List<ServicesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesModel {
  ServicesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  String id;
  String title;
  String description;
  String status;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
      };
}
