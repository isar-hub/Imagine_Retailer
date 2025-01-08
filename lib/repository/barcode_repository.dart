import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/Product.dart';

import '../models/Users.dart';
import '../models/user_singleton.dart';

class BarcodeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Users? user = UserSingleton().getUser();

  Future<Result<Product>> fetchProduct(String serialNumber) async {
    try {

      log(serialNumber);
      var doc =
          await _firestore.collection("all-products").doc(serialNumber).get();
      if (doc.exists) {
        log("Product Found ${doc.data()}");
        return Result.success(
            Product.fromJson(doc.data() as Map<String, dynamic>));
      } else {
        log("Product Not Found");
        return Result.error("Product not found");
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      return Result.error("Error : ${e}");
    }
  }
}
