// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  UsersModel({
    required this.createdOn,
    required this.email,
    this.name,
    this.phone,
    this.photo,
    required this.uid,
    this.state,
    this.statePostal,
    this.city,
    this.gender,
    this.dob,
  });

  String createdOn;
  String email;
  String? name;
  String? phone;
  String? photo;
  String uid;
  String? state;
  String? statePostal;
  String? city;
  String? gender;
  String? dob;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        createdOn: json["createdOn"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        photo: json["photo"],
        uid: json["uid"],
        state: json["state"],
        statePostal: json["statePostal"],
        city: json["city"],
        gender: json["gender"],
        dob: json["dob"],
      );

  Map<String, dynamic> toJson() => {
        "createdOn": createdOn,
        "email": email,
        "name": name,
        "phone": phone,
        "photo": photo,
        "uid": uid,
        "state": state,
        "statePostal": statePostal,
        "city": city,
        "gender": gender,
        "dob": dob,
      };
}
