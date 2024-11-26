import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/Product.dart';

class BarCodeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var quantity = ''.obs;
  var errorText = ''.obs;
  late final TextEditingController quantityController;

  var product = Rx<Result<Product>>(Result.loading());

  late String barCode;
  @override
  void onReady() {
    fetchProduct(barCode);
  }

  @override
  void onInit() {
    super.onInit();
    barCode = Get.arguments;
    quantityController = TextEditingController();
  }

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }

  void fetchProduct(String serialNumber) async {
    try {
      log(serialNumber);
      var doc = await _firestore.collection("products").doc(serialNumber).get();
      if (doc.exists) {
        product.value =
            Result.success(Product.fromJson(doc.data() as Map<String, dynamic>));
      } else {
        log("Product Not Found");
        product.value = Result.error("Product not found");
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      product.value = Result.error("Error : ${e}");
    }
  }

  void validateInput(String input) {
    if (input.isEmpty) {
      errorText.value = 'Quantity cannot be empty';
    } else if (int.tryParse(input) == null) {
      errorText.value = 'Please enter a valid number';
    } else {
      errorText.value = '';
    }
  }
}
