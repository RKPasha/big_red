// To parse this JSON data, do
//
//     final carsModel = carsModelFromJson(jsonString);

import 'dart:convert';

List<CarsModel> carsModelFromJson(String str) =>
    List<CarsModel>.from(json.decode(str).map((x) => CarsModel.fromJson(x)));

String carsModelToJson(List<CarsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarsModel {
  CarsModel({
    required this.trimId,
    required this.trim,
    required this.makeId,
    required this.make,
    required this.modelId,
    required this.model,
    required this.generationId,
    required this.generation,
    required this.bodyId,
    required this.body,
    required this.driveId,
    required this.drive,
    required this.gearboxId,
    required this.gearbox,
    required this.engineTypeId,
    required this.engineType,
    required this.engineVolume,
    required this.enginePower,
    required this.year,
    required this.image,
    required this.dateUpdate,
    required this.isActive,
  });

  String trimId;
  String trim;
  String makeId;
  String make;
  String modelId;
  String model;
  String generationId;
  String generation;
  String bodyId;
  String body;
  String driveId;
  String drive;
  String gearboxId;
  String gearbox;
  String engineTypeId;
  String engineType;
  String engineVolume;
  String enginePower;
  String year;
  String image;
  DateTime dateUpdate;
  String isActive;

  factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
        trimId: json["trim_id"],
        trim: json["trim"],
        makeId: json["make_id"],
        make: json["make"],
        modelId: json["model_id"],
        model: json["model"],
        generationId: json["generation_id"],
        generation: json["generation"],
        bodyId: json["body_id"],
        body: json["body"],
        driveId: json["drive_id"],
        drive: json["drive"],
        gearboxId: json["gearbox_id"],
        gearbox: json["gearbox"],
        engineTypeId: json["engine_type_id"],
        engineType: json["engine_type"],
        engineVolume: json["engine_volume"],
        enginePower: json["engine_power"],
        year: json["year"],
        image: json["image"],
        dateUpdate: DateTime.parse(json["date_update"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "trim_id": trimId,
        "trim": trim,
        "make_id": makeId,
        "make": make,
        "model_id": modelId,
        "model": model,
        "generation_id": generationId,
        "generation": generation,
        "body_id": bodyId,
        "body": body,
        "drive_id": driveId,
        "drive": drive,
        "gearbox_id": gearboxId,
        "gearbox": gearbox,
        "engine_type_id": engineTypeId,
        "engine_type": engineType,
        "engine_volume": engineVolume,
        "engine_power": enginePower,
        "year": year,
        "image": image,
        "date_update":
            "${dateUpdate.year.toString().padLeft(4, '0')}-${dateUpdate.month.toString().padLeft(2, '0')}-${dateUpdate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
      };
}
