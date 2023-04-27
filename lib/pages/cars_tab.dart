import 'package:big_red/models/carsModel.dart';
import 'package:big_red/services/carServices.dart';
import 'package:flutter/material.dart';

class CarsTab extends StatefulWidget {
  const CarsTab({super.key});

  @override
  State<CarsTab> createState() => _CarsTabState();
}

class _CarsTabState extends State<CarsTab> {
  final _firestoreService = CarService();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _firestoreService.getCars();
        });
      },
      child: StreamBuilder<List<CarsModel>>(
        stream: _firestoreService.getCars(),
        builder: (context, AsyncSnapshot<List<CarsModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars found  :('));
          }

          final cars = snapshot.data!;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];

              return ListTile(
                title: Text(car.make),
                subtitle: Text(car.model),
              );
            },
          );
        },
      ),
    );
  }
}
