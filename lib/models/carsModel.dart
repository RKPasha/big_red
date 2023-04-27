// To parse this JSON data, do
//
//     final carsModel = carsModelFromJson(jsonString);

enum BodyType {
  sedan,
  suv,
  hatchback,
  coupe,
  pickupTruck,
  van,
  wagon,
}

enum FuelType {
  petrol,
  diesel,
  hybrid,
  electric,
}

enum TransmissionType {
  manual,
  automatic,
}

enum DriveType { frontWheel, rearWheel, allWheel, _4x4 }

enum Condition {
  New,
  Used,
}

extension DriveTypeExtension on DriveType {
  String get value => {
        DriveType.frontWheel: 'Front Wheel Drive',
        DriveType.rearWheel: 'Rear Wheel Drive',
        DriveType.allWheel: 'All Wheel Drive',
        DriveType._4x4: '4x4'
      }[this]!;
}

extension BodyTypeExtension on BodyType {
  String get value => {
        BodyType.sedan: 'Sedan',
        BodyType.suv: 'SUV',
        BodyType.hatchback: 'Hatchback',
        BodyType.coupe: 'Coupe',
        BodyType.pickupTruck: 'Pickup Truck',
        BodyType.van: 'Van',
        BodyType.wagon: 'Wagon',
      }[this]!;
}

extension FuelTypeExtension on FuelType {
  String get value => {
        FuelType.petrol: 'Petrol',
        FuelType.diesel: 'Diesel',
        FuelType.hybrid: 'Hybrid',
        FuelType.electric: 'Electric',
      }[this]!;
}

extension TransmissionTypeExtension on TransmissionType {
  String get value => {
        TransmissionType.manual: 'Manual',
        TransmissionType.automatic: 'Automatic',
      }[this]!;
}

extension ConditionExtension on Condition {
  String get value => {
        Condition.New: 'New',
        Condition.Used: 'Used',
      }[this]!;
}

class CarsModel {
  CarsModel({
    required this.carId,
    required this.trim,
    required this.make,
    required this.model,
    required this.generation,
    required this.bodyType,
    required this.driveType,
    required this.transmissionType,
    required this.fuelType,
    required this.condition,
    required this.engineVolume,
    required this.enginePower,
    required this.year,
    required this.price,
    this.imageUrls,
    required this.dateUpdate,
    this.isActive,
    this.isFeatured,
  });

  String carId;
  String trim;
  String make;
  String model;
  String generation;
  BodyType bodyType;
  DriveType driveType;
  TransmissionType transmissionType;
  FuelType fuelType;
  Condition condition;
  double engineVolume;
  double enginePower;
  String year;
  double price;
  List<String>? imageUrls;
  DateTime dateUpdate;
  bool? isActive = true;
  bool? isFeatured = false;

  factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
        carId: json["carId"],
        trim: json["trim"],
        make: json["make"],
        model: json["model"],
        generation: json["generation"],
        bodyType: BodyType.values.firstWhere(
            (type) => type.toString() == 'BodyType.${json['body_type']}'),
        driveType: DriveType.values.firstWhere(
            (type) => type.toString() == 'DriveType.${json['drive_type']}'),
        transmissionType: TransmissionType.values.firstWhere((type) =>
            type.toString() == 'TransmissionType.${json['transmission_type']}'),
        fuelType: FuelType.values.firstWhere(
            (type) => type.toString() == 'FuelType.${json['fuel_type']}'),
        condition: Condition.values.firstWhere(
            (type) => type.toString() == 'Condition.${json['condition']}'),
        engineVolume: json["engine_volume"].toDouble(),
        enginePower: json["engine_power"].toDouble(),
        year: json["year"],
        price: json["price"].toDouble(),
        imageUrls: List<String>.from(json["imageUrls"]),
        dateUpdate: DateTime.parse(json["date_update"]),
        isActive: json["is_active"],
        isFeatured: json["is_featured"],
      );

  Map<String, dynamic> toJson() => {
        "carId": carId,
        "trim": trim,
        "make": make,
        "model": model,
        "generation": generation,
        "body_type": bodyType.toString().split('.').last,
        "drive_type": driveType.toString().split('.').last,
        "transmission_type": transmissionType.toString().split('.').last,
        "fuel_type": fuelType.toString().split('.').last,
        "condition": condition.toString().split('.').last,
        "engine_volume": engineVolume,
        "engine_power": enginePower,
        "year": year,
        "price": price,
        "imageUrls": imageUrls,
        "date_update": dateUpdate.toIso8601String(),
        "is_active": isActive ?? true,
        "is_featured": isFeatured ?? false,
      };
}
