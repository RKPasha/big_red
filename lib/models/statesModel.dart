import 'dart:convert';

List<StatesModel> statesModelFromJson(String str) => List<StatesModel>.from(
    json.decode(str).map((x) => StatesModel.fromJson(x)));

String statesModelToJson(List<StatesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatesModel {
  StatesModel({
    required this.name,
    required this.iso2,
  });

  String name;
  String iso2;

  factory StatesModel.fromJson(Map<String, dynamic> json) => StatesModel(
        name: json["name"],
        iso2: json["iso2"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iso2": iso2,
      };
}
