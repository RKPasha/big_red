import 'package:big_red/models/carsModel.dart';
import 'package:big_red/models/servicesModel.dart';
import 'package:big_red/models/usersModel.dart';
// import 'package:big_red/pages/car_details.dart';
import 'package:big_red/pages/services_details.dart';
import 'package:big_red/pages/services_form.dart';
import 'package:big_red/services/services.dart';
import 'package:big_red/services/userServices.dart';
import 'package:big_red/utils/side_navbar.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CarsModel> cars = [];
  Stream<List<ServicesModel>> get servicesListView async* {
    yield await Service.getData();
  }

  Stream<UsersModel> get tempUser async* {
    yield await UserService.getUserFromDatabase(widget.user.uid);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersModel>(
        stream: tempUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    servicesListView;
                  });
                },
                child: Scaffold(
                  drawer: SideNav(
                      user: widget.user,
                      usersModel: snapshot.data as UsersModel),
                  appBar: AppBar(
                    title: Center(
                      child: Text('Big-Red Auto Sales',
                          style: GoogleFonts.robotoSlab(
                              textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ))),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  body: StreamBuilder(
                    stream: servicesListView,
                    builder:
                        (context, AsyncSnapshot<List<ServicesModel>> snapshot) {
                      if (snapshot.hasData) {
                        List<ServicesModel>? services = snapshot.data;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            ServicesModel service = services![index];
                            return GestureDetector(
                              onTap: () async {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => CarDetails(
                                //       car: snapshot.data![index],
                                //     ),
                                //   ),
                                // );
                                bool somethingHappens =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ServiceDetails(
                                      service: services[index],
                                    ),
                                  ),
                                );
                                if (somethingHappens == true) {
                                  setState(() {
                                    servicesListView;
                                  });
                                }
                              },
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  title: Text(
                                    service.title,
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  subtitle: Text(
                                    service.description,
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                    maxLines: 2,
                                  ),
                                  trailing: Text(
                                    service.status,
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
                  floatingActionButton: FloatingActionButton(
                    onPressed: (() async {
                      bool somethingHappens = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ServicesFrom(service: null),
                        ),
                      );
                      if (somethingHappens == true) {
                        setState(() {
                          servicesListView;
                        });
                      }
                    }),
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ));
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'user fetch krny me msla aa rha hai ${snapshot.error}'));
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        });
  }

  // Future<List<CarsModel>> getData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://databases.one/api/?format=json&select=all&api_key=Your_Database_Api_Key'));
  //   if (response.statusCode == 200) {
  //     var responseJson = json.decode(response.body)['result'];
  //     var uniqueModels = <String>{};
  //     var uniqueResult = responseJson.where((responseJson) {
  //       var isUnique = uniqueModels.add(responseJson['model']);
  //       return isUnique;
  //     });
  //     for (Map<String, dynamic> index in uniqueResult) {
  //       cars.add(CarsModel.fromJson(index));
  //     }
  //     return cars;
  //   } else {
  //     throw Exception('Failed to load cars');
  //     // return cars;
  //   }
  // }
}
