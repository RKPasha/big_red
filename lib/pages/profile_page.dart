import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:big_red/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:big_red/models/usersModel.dart';
import 'package:big_red/models/statesModel.dart';
import 'package:big_red/pages/home_page.dart';
import 'package:big_red/services/userServices.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final UsersModel usersModel;
  const ProfilePage({super.key, required this.user, required this.usersModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  List<StatesModel> _stateList = [];

  String? _selectedState;
  String? _selectedStatePostal;
  String? _selectedCity;
  String? _selectedGender;

  XFile? _imageFile;
  String? _imageUrl;
  Uint8List? selectedImageinBytes;
  // DateTime? _selectedDate;
  // List<dynamic> _cities = [];
  final List<String> _gender = ["Male", "Female", "Prefer not to say"];

  late Future<List<StatesModel>> stateListFuture;
  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      //backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(),
                    ),
                    onTap: () {
                      _selectFile(true);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(),
                  ),
                  onTap: () {
                    _selectFile(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // debugPrint(widget.usersModel.photo!.startsWith('https').toString());
    _fetchImageUrlFromDatabase();
    stateListFuture = UserService.getStates(_stateList);
    if (widget.usersModel.uid != '123') {
      _nameController.text = widget.usersModel.name ?? '';
      // _contactNumberController.text =
      //     (widget.usersModel.phone == 'null' ? '' : widget.usersModel.phone!);
      _dobController.text = widget.usersModel.dob ??
          DateFormat.yMMMMd().format(DateTime.now()).toString();
      _selectedStatePostal = widget.usersModel.statePostal;
      _selectedCity = widget.usersModel.city;
      _selectedGender = widget.usersModel.gender;
      // _imageUrl = widget.usersModel.photo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return ChangeNotifierProvider<MyModel>(
      create: (context) => MyModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Complete your Profile',
                  style: GoogleFonts.robotoSlab(
                      textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ))),
            ),
            // automaticallyImplyLeading: false,
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (kIsWeb) {
                            _selectFile(true);
                          } else {
                            _showPicker(context);
                          }
                        },
                        child: CircleAvatar(
                          radius: 64.0,
                          backgroundColor: Colors.white,
                          child: _imageUrl != null
                              ? ClipOval(
                                  child: _imageUrl!.startsWith('https')
                                      ? Image.network(
                                          _imageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : kIsWeb
                                          ? Image.memory(selectedImageinBytes!)
                                          : Image.file(File(_imageFile!.path)),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    'assets/images/person.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _imageUrl != null && !_imageUrl!.startsWith('https')
                          ? IconButton(
                              onPressed: _uploadImage,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red[400]),
                                elevation: MaterialStateProperty.all(15),
                              ),
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.grey,
                                size: 30,
                              ))
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Member Since ${DateFormat.yMMMMd().format(user.metadata.creationTime!)}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: user.email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                        hintText: '+1xxxxxxxxxx'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (!isPhoneNumber(value!)) {
                          return 'Please enter valid contact number';
                        }
                        return null;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  FutureBuilder<List<StatesModel>>(
                    future: stateListFuture,
                    builder:
                        (context, AsyncSnapshot<List<StatesModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data available');
                      } else {
                        _stateList = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: _selectedStatePostal,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            border: OutlineInputBorder(),
                          ),
                          items: snapshot.data!.map((state) {
                            return DropdownMenuItem<String>(
                              value: state.iso2,
                              child: Text(state.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatePostal = value;
                              _selectedState = _stateList
                                  .firstWhere((s) => s.iso2 == value)
                                  .name;
                              _selectedCity = null;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                      future: UserService.getCities(_selectedStatePostal),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('No data available');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: _selectedCity,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                            items: snapshot.data!.map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _selectedCity = value;
                              // setState(() {
                              // });
                            },
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select your city';
                            //   }
                            //   return null;
                            // },
                          );
                        }
                      }),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender (optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: _gender
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _selectedGender = value!;
                      // setState(() {});
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth (optional)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(widget.usersModel.dob!),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            _dobController.text = DateFormat.yMMMMd()
                                .format(selectedDate)
                                .toString();
                            // setState(() {
                            // });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')));
                          //create UsersMuodel object and assign values to it
                          widget.usersModel.name = _nameController.text.trim();
                          widget.usersModel.phone =
                              _contactNumberController.text;
                          widget.usersModel.state = _selectedState;
                          widget.usersModel.statePostal = _selectedStatePostal;
                          widget.usersModel.city = _selectedCity;
                          widget.usersModel.gender = _selectedGender;
                          widget.usersModel.dob = _dobController.text;
                          widget.usersModel.photo = _imageUrl;

                          UserService.updateUserToDatabase(
                              widget.usersModel, context);
                          //debugPrint all data on debug console

                          // Save the data to the database or send it to the server
                          _formKey.currentState!.save();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(user: widget.user)));
                        }
                      },
                      child: const Text(
                        'Save & Let\'s get started!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  bool isValidName(String value) {
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(value);
  }

  bool isPhoneNumber(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  _selectFile(bool imageFrom) async {
    if (kIsWeb) {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
      if (fileResult != null) {
        setState(() {
          _imageUrl = fileResult.files.first.name;
          selectedImageinBytes = fileResult.files.first.bytes;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: imageFrom ? ImageSource.gallery : ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _imageUrl = pickedFile.name;
        });
      }
      debugPrint(_imageUrl);
    }
  }

  _uploadImage() async {
    try {
      UploadTask uploadTask;
      if (kIsWeb) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars/${widget.user.uid}.jpeg');
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = storageRef.putData(selectedImageinBytes!, metadata);
      } else {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars/${widget.user.uid}}}');
        uploadTask = storageRef.putFile(File(_imageFile!.path));
      }

      final snapshot = await uploadTask.whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image is uploading...'),
          ),
        );
      });
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });

      await _saveImageUrlToDatabase(downloadUrl);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _saveImageUrlToDatabase(String imageUrl) async {
    await FirebaseDatabase.instance.ref('users').child(widget.user.uid).update({
      'photo': imageUrl,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image successfully uploaded!'),
        ),
      );
    });
  }

  Future<void> _fetchImageUrlFromDatabase() async {
    final ref = FirebaseDatabase.instance.ref('users/${widget.user.uid}');
    final snapshot = await ref.child('photo').get();

    if (snapshot.exists) {
      setState(() {
        _imageUrl = snapshot.value as String?;
      });
    }
  }
}

class MyModel with ChangeNotifier {}
