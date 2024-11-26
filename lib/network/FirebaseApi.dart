import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/models/Customers.dart';
import 'package:imagine_retailer/models/warranty_model.dart';

class FirebaseApi {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Result<String>> updateWarranty(
      List<Warranty> data, String serialNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(serialNumber)
          .update(
              {"warranty": data.map((warranty) => warranty.toMap()).toList()});
      return Result.success('Warranty Updated Successfully');
    } on FirebaseException catch (e) {
      showError("${e.message}");
      return Result.error(e.message!);
    }
  }

  Future<Result<List<String>>> uploadMultipleImage(
      String path, List<XFile> image) async {
    try {
      List<String> downloadUrls = await Future.wait(
        image.map((image) async {
          var firebaseRef =
              FirebaseStorage.instance.ref(path).child(image.name);
          await firebaseRef.putFile(File(image.path));
          return await firebaseRef.getDownloadURL();
        }).toList(),
      );
      return Result.success(downloadUrls);
    } on FirebaseException catch (e) {
      showError("${e.message}");
      return Result.error(e.message!);
    }
  }

  Future<Result<String>> saveCustomerDetails(
      CustomerInfo user, String serialNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(serialNumber)
          .update(user.toMap());
      return Result.success('Product Updated Successfully');
    } on FirebaseException catch (e) {
      showError("${e.message}");
      return Result.error(e.message!);
    }
  }

  Future<Result<String>> uploadImage(String path, XFile image) async {
    try {
      var firebaseRef = FirebaseStorage.instance.ref(path).child(image.name);
      await firebaseRef.putFile(File(image.path));
      final url = await firebaseRef.getDownloadURL();
      return Result.success(url);
    } on FirebaseException catch (e) {
      showError("${e.message}");
      return Result.error(e.message!);
    }
  }

  Future<Result<String>> uploadSignature(String path, Uint8List image) async {
    try {
      var firebaseRef = FirebaseStorage.instance.ref(path).child(now());
      await firebaseRef.putData(image);
      final url = await firebaseRef.getDownloadURL();
      return Result.success(url);
    } on FirebaseException catch (e) {
      showError("${e.message}");

      return Result.error(e.message!);
    }
  }
}
