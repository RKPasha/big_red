import 'dart:io';

import 'package:big_red/models/carsModel.dart';
import 'package:big_red/utils/loading_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;

class CarService {
  static final CollectionReference _carsCollection =
      FirebaseFirestore.instance.collection('cars');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> addCar(
      CarsModel car, List<Asset> imageUrls, BuildContext context) async {
    try {
      final docRef = await _carsCollection.add(car.toJson());
      final carId = docRef.id;
      await docRef.update({'carId': carId});
      if (context.mounted) {}
      await uploadImages(imageUrls, carId, context);
      return carId;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return 'error';
    }
  }

  Future<void> updateCar(
      CarsModel car, List<Asset> imageUrls, BuildContext context) async {
    await _carsCollection.doc(car.carId).update(car.toJson());
    if (context.mounted) {}
    await uploadImages(imageUrls, car.carId, context);
  }

  Future<void> deleteCar(String carId) async {
    await _carsCollection.doc(carId).delete();
    await _deleteImages(carId);
  }

  Stream<List<CarsModel>> getCars() {
    return _carsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        return CarsModel.fromJson(data);
      }).toList();
    });
  }

  static Future<void> uploadImages(
      List<Asset> images, String carId, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingModal(message: 'Posting your Ad...');
        },
      );

      final storage = FirebaseStorage.instance;
      // Create a reference to the car's storage folder
      final carStorageRef = storage.ref('cars/$carId');

      // Upload each image to storage and store its URL in a list
      final imageUrls = <String>[];
      for (final asset in images) {
        // Get a byte data representation of the image
        final byteData = await asset.getByteData();
        final imageData = byteData.buffer.asUint8List();
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String filePath = '$tempPath/${Path.basename(asset.name!)}';
        File file = File(filePath);
        await file.writeAsBytes(imageData);

        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(filePath);
        File compressedFile = await FlutterNativeImage.compressImage(filePath,
            quality: 50,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / properties.width!).round());

        // Create a reference to the image in storage and upload the data
        final imageName =
            '${const Uuid().v4()}.jpg'; // Generate a unique name for each image
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        final imageRef = carStorageRef.child(imageName);

        UploadTask uploadTask = imageRef.putFile(compressedFile, metadata);
        TaskSnapshot storageTaskSnapshot =
            await uploadTask.whenComplete(() => {});
        // Get the download URL for the image and store it in the list
        final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
        if (kDebugMode) {
          print(downloadUrl);
        }
      }

      // Save the image URLs to the car document in Firestore
      await saveImages(carId, imageUrls).then((value) {
        //show snackbar
        Navigator.pop(context);
      });
    } catch (e) {
      //show snackbar
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading images'),
        ),
      );
    }
  }

  static Future<void> saveImages(String carId, List<String> imageUrls) async {
    final storageRef = _storage.ref('cars/$carId');

    // Delete any images in storage that are not in the provided list of image URLs
    final snapshot = await storageRef.listAll();
    for (var item in snapshot.items) {
      final url = await item.getDownloadURL();
      if (!imageUrls.contains(url)) {
        await item.delete();
      }
    }
    // final urlMap =
    //     imageUrls.asMap().map((i, url) => MapEntry('url${i + 1}', url));
    await FirebaseFirestore.instance
        .collection('cars')
        .doc(carId)
        .update({'imageUrls': imageUrls});
  }

  Future<void> _deleteImages(String carId) async {
    final storageRef = _storage.ref('cars/$carId');
    await storageRef.delete();
    final imagesCollection = _carsCollection.doc(carId).collection('images');
    final snapshot = await imagesCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
