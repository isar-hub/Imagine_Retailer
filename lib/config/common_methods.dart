import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError(String message) {
  Get.snackbar("Error", message, backgroundColor: Colors.red);
}

void showSuccess(String message){
  Get.snackbar("Success", message, backgroundColor: Colors.green,barBlur: 10);
}
