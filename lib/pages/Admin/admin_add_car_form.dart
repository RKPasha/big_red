import 'package:big_red/models/carsModel.dart';
import 'package:big_red/pages/Admin/admin_home.dart';
import 'package:big_red/services/carServices.dart';
import 'package:big_red/utils/custom_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

class AddCarForm extends StatefulWidget {
  const AddCarForm({super.key});

  @override
  State<AddCarForm> createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _trimController = TextEditingController();
  final TextEditingController _generationController = TextEditingController();
  final TextEditingController _engineVolumeController = TextEditingController();
  final TextEditingController _enginePowerController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<String> _selectedImages = [];
  BodyType _selectedBodyType = BodyType.sedan;
  FuelType _selectedFuelType = FuelType.petrol;
  TransmissionType _selectedTransmissionType = TransmissionType.manual;
  DriveType _selectedDriveType = DriveType.frontWheel;
  Condition _selectedCondition = Condition.New;

  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  User? user = FirebaseAuth.instance.currentUser;

  Widget buildGridView() {
    return Wrap(
      spacing: 1.0, // set spacing between images
      runSpacing: 1.0, // set run spacing between rows
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3 -
              10.0, // divide screen width by 3 and subtract spacing
          height: MediaQuery.of(context).size.width / 3 -
              10.0, // set the same height as width to make it square
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 15,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#f44336",
          actionBarTitle: "Big Red Auto Sales",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Car',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _makeController,
                    decoration: const InputDecoration(
                      labelText: 'Make',
                      hintText: 'Toyota, Honda, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your car make';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      hintText: 'Corolla, Civic, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your car model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _trimController,
                    decoration: const InputDecoration(
                      labelText: 'Trim',
                      hintText: 'Base, Sport, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your car trim';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _generationController,
                    decoration: const InputDecoration(
                      labelText: 'Generation',
                      hintText: 'Ist, 2nd, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your car generation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _engineVolumeController,
                    decoration: const InputDecoration(
                      labelText: 'Engine Volume (cc)',
                      hintText: '660, 1.5, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter engine volume';
                      }
                      final double? engineVolume = double.tryParse(value);
                      if (engineVolume == null || engineVolume <= 0) {
                        return 'Please enter valid engine volume';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _enginePowerController,
                    decoration: const InputDecoration(
                      labelText: 'Engine Power (hp)',
                      hintText: '100, 150, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter engine power';
                      }
                      final double? enginePower = double.tryParse(value);
                      if (enginePower == null || enginePower <= 0) {
                        return 'Please enter valid engine power';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Registration Year',
                      hintText: '2010, 2015, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter rregistration year';
                      }
                      final RegExp yearRegex = RegExp(r'^\d{4}$');
                      if (!yearRegex.hasMatch(value)) {
                        return 'Please enter valid registration year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (\$)',
                      hintText: '100000, 200000, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      final double? price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Please enter valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomDropDown(
                      dropdownFor: 'Body Type',
                      items: BodyType.values.map((BodyType bodyType) {
                        return DropdownMenuItem<BodyType>(
                          value: bodyType,
                          child: Text(bodyType.value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBodyType = newValue!;
                        });
                      },
                      value: _selectedBodyType),
                  const SizedBox(height: 16.0),
                  CustomDropDown(
                      dropdownFor: 'Fuel Type',
                      items: FuelType.values
                          .map(
                            (fuelType) => DropdownMenuItem(
                              value: fuelType,
                              child: Text(fuelType.value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedFuelType = value as FuelType),
                      value: _selectedFuelType),
                  const SizedBox(height: 16.0),
                  CustomDropDown(
                    dropdownFor: 'Transmission Type',
                    items: TransmissionType.values
                        .map(
                          (transmissionType) => DropdownMenuItem(
                            value: transmissionType,
                            child: Text(
                                EnumToString.convertToString(transmissionType)
                                    .toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() =>
                        _selectedTransmissionType = value as TransmissionType),
                    value: _selectedTransmissionType,
                  ),
                  const SizedBox(height: 16.0),
                  CustomDropDown(
                      dropdownFor: 'Drive Type',
                      items: DriveType.values.map((DriveType driveType) {
                        return DropdownMenuItem<DriveType>(
                          value: driveType,
                          // child: Text(EnumToString.convertToString(driveType.value).toUpperCase()),
                          child: Text(driveType.value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDriveType = newValue!;
                        });
                      },
                      value: _selectedDriveType),
                  const SizedBox(height: 16.0),
                  CustomDropDown(
                      value: _selectedCondition,
                      dropdownFor: 'Condition',
                      items: Condition.values.map((Condition condition) {
                        return DropdownMenuItem<Condition>(
                          value: condition,
                          child: Text(
                            condition.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCondition = value!;
                        });
                      }),
                  const SizedBox(height: 16.0),
                  Text('Error: $_error'),
                  ElevatedButton(
                    onPressed: loadAssets,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.image, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Pick Images',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  images.isNotEmpty
                      ? const SizedBox(height: 16.0)
                      : const SizedBox(height: 0.0),
                  if (images.isNotEmpty)
                    SizedBox(
                      child: buildGridView(),
                    ),
                  const SizedBox(height: 16.0),
                  // Elevated submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (images.isEmpty) {
                            setState(() {
                              _error = 'Please select at least one image';
                            });
                            return;
                          } else {
                            _submitForm();
                          }
                        }
                      },
                      child: const Text(
                        'Post Add',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final CarsModel car = CarsModel(
      carId: '',
      trim: _trimController.text,
      make: _makeController.text,
      model: _modelController.text,
      generation: _generationController.text,
      bodyType: _selectedBodyType,
      driveType: _selectedDriveType,
      transmissionType: _selectedTransmissionType,
      fuelType: _selectedFuelType,
      engineVolume: double.parse(_engineVolumeController.text),
      enginePower: double.parse(_enginePowerController.text),
      year: _yearController.text,
      price: double.parse(_priceController.text),
      dateUpdate: DateTime.now(),
      condition: _selectedCondition,
    );
    await CarService.addCar(car, images, context).then((value) {
      if (value != 'error') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ad Posted successfully'),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminHomePage(user: user!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error posting ad'),
          ),
        );
      }
    });
    if (kDebugMode) {
      print(car.toJson());
    }
  }
}
