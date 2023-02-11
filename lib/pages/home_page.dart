import 'dart:convert';

import 'package:big_red/models/carsModel.dart';
import 'package:big_red/pages/car_details.dart';
import 'package:big_red/utils/side_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CarsModel> cars = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
      appBar: AppBar(
        title: Center(
          child: Text('Big-Red Auto Deals',
              style: GoogleFonts.robotoSlab(
                  textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ))),
        ),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final data = snapshot.data;
            List<List<dynamic>> pages = <List<dynamic>>[];
            for (int i = 0; i < cars.length; i += 15) {
              pages.add(
                  cars.sublist(i, i + 15 > cars.length ? cars.length : i + 15));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CarDetails(
                          car: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(
                        snapshot.data![index].make,
                        style: GoogleFonts.robotoSlab(
                            textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      subtitle: Text(
                        snapshot.data![index].model,
                        style: GoogleFonts.robotoSlab(
                            textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      trailing: Text(
                        snapshot.data![index].year,
                        style: GoogleFonts.robotoSlab(
                            textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        },
      ),
    );
  }

  Future<List<CarsModel>> getData() async {
    final response = await http.get(Uri.parse(
        'https://databases.one/api/?format=json&select=all&api_key=Your_Database_Api_Key'));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body)['result'];
      var uniqueModels = <String>{};
      var uniqueResult = responseJson.where((responseJson) {
        var isUnique = uniqueModels.add(responseJson['model']);
        return isUnique;
      });
      // debugPrint(results);
      for (Map<String, dynamic> index in uniqueResult) {
        cars.add(CarsModel.fromJson(index));
      }
      return cars;
    } else {
      throw Exception('Failed to load cars');
      // return cars;
    }
  }
}
