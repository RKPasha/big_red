import 'dart:convert';
import 'dart:io';

import 'package:big_red/models/servicesModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Service {
  static String url = 'https://pcc.edu.pk/ws/bscs2020/services.php';

  static Future<List<ServicesModel>> getData() async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String content = response.body;
        List collection = json.decode(content);
        List<ServicesModel> services =
            collection.map((json) => ServicesModel.fromJson(json)).toList();
        return services;
      } else {
        throw Exception('Failed to load services');
        // return cars;
      }
    } catch (error) {
      return [];
    }
  }

  static Future<int> putData(Object data, BuildContext context) async {
    try {
      final response = await http.put(Uri.parse(url), body: jsonEncode(data));
      return response.statusCode;
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service Not Updated. ${e.message}'),
        ),
      );
      return 0;
    }
  }

  static Future<int> postData(Object data, BuildContext context) async {
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data));
      return response.statusCode;
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service Not Added. ${e.message}'),
        ),
      );
      return 0;
    }
  }

  static Future<int> deleteData(Object data, BuildContext context) async {
    try {
      final response =
          await http.delete(Uri.parse(url), body: jsonEncode(data));
      debugPrint(response.reasonPhrase);
      return response.statusCode;
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service Not Deleted. ${e.message}'),
        ),
      );
      return 0;
    }
  }
}
