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
  final firestore = FirebaseFirestore.instance;

  var j = FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  Future<Result<String>> updateWarranty(
      List<Warranty> data, String serialNumber) async {
    try {
      await firestore.runTransaction((transction) async {
        final warrantyRef = firestore.collection("warranty").doc(serialNumber);
        transction.set(warrantyRef, data);
      });

      return Result.success('Warranty Updated Successfully');
    } on FirebaseException catch (e) {
      showError("${e.message}");
      return Result.error(e.message!);
    } catch (e) {
      return Result.error('Unexpected Error: $e');
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
    final firestore = FirebaseFirestore.instance;

    try {
      // Use a transaction to ensure atomicity
      await firestore.runTransaction((transaction) async {
        print(
            "Starting Firestore transaction for serial number: $serialNumber");

        // Update customer details
        final customerRef = firestore.collection("customers").doc(serialNumber);
        transaction.set(customerRef, user.toJson());
        print("Customer details updated in Firestore.");

        final historyEntry = {
          'status': 'sold',
          'timestamp': Timestamp.now(),
        };
        var userUpdate = {
          'status': 'sold',
          'warrantyStarted': user.warrantyStarted,
          'warrantyEnded': user.warrantyEnded,
        };

        // Update product warranty status
        final productRef =
            firestore.collection("all-products").doc(serialNumber);
        transaction.update(productRef, userUpdate);
      });

      print("Firestore transaction completed successfully.");
      return Result.success('Product Updated Successfully');
    }  catch (e) {
      print('Catch exception: $e');
      return Result.error('Unexpected Error: $e');
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
