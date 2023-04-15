import 'dart:convert';

import 'package:big_red/models/statesModel.dart';
import 'package:big_red/models/usersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UsersModel> getUserFromDatabase(String userId) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<Object?, Object?>;
      final json = Map<String, dynamic>.from(data).cast<String, dynamic>();
      return UsersModel.fromJson(json);
      // debugPrint(_usersModel.name);
    } else {
      debugPrint('No data available.');
      return UsersModel(createdOn: '123', email: 'abc', uid: '123');
    }
  }

  static Future<void> updateUserToDatabase(
      UsersModel usersModel, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(usersModel.uid)
        .update({
      'name': usersModel.name,
      'phone': usersModel.phone,
      'gender': usersModel.gender,
      'state': usersModel.state,
      'statePostal': usersModel.statePostal,
      'city': usersModel.city,
      'dob': usersModel.dob,
      'photo': usersModel.photo,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User Not Updated. Error: $error'),
        ),
      );
    });
  }

  static Future<List<StatesModel>> getStates(
      List<StatesModel> stateList) async {
    final response = await http.get(
        Uri.parse('https://api.countrystatecity.in/v1/countries/US/states'),
        headers: {
          "X-CSCAPI-KEY":
              "dG11RlpaT1lxQ0tQbnROZGRMZmJqdUtGeUpYeU1Pc1plNFJUQjdyRg=="
        });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      stateList = data.map((json) => StatesModel.fromJson(json)).toList();
      stateList.sort((a, b) => a.name.compareTo(b.name));
      return stateList;
    } else {
      throw Exception('Failed to fetch states');
    }
  }

  static Future<List> getCities(String? state) async {
    final response = await http.get(
        Uri.parse(
            'https://api.countrystatecity.in/v1/countries/US/states/$state/cities'),
        headers: {
          "X-CSCAPI-KEY":
              "dG11RlpaT1lxQ0tQbnROZGRMZmJqdUtGeUpYeU1Pc1plNFJUQjdyRg=="
        });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((state) => state['name']).toList().cast<String>();
    } else {
      throw Exception('Failed to fetch cities');
    }
  }
}
