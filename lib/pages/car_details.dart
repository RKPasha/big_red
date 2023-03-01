import 'package:big_red/models/carsModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarDetails extends StatelessWidget {
  final CarsModel car;
  const CarDetails({super.key, required this.car});

  double getTrim(String trim) {
    RegExp exp = RegExp(r"\d+\.\d+");
    var match = exp.firstMatch(trim);
    if (match != null) {
      return double.parse(match.group(0)!);
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          '${car.make} ${car.model}',
          style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
        )),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          InfoRow(title: 'Make', desc: car.make),
          InfoRow(title: 'Model', desc: car.model),
          InfoRow(title: 'Trim', desc: getTrim(car.trim).toString()),
          InfoRow(title: 'Year', desc: car.year),
          InfoRow(title: 'Generation', desc: car.generation),
          InfoRow(title: 'Body', desc: car.body),
          InfoRow(title: 'Drive', desc: car.drive),
          InfoRow(title: 'Gearbox', desc: car.gearbox),
          InfoRow(title: 'Engine Type', desc: car.engineType),
          InfoRow(title: 'Engine Volume', desc: car.engineVolume),
          InfoRow(title: 'Engine Power', desc: '${car.enginePower} hp'),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String desc;
  const InfoRow({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 26))),
        ],
      ),
    );
  }
}
