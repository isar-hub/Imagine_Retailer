import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BarCodeController extends GetxController{

  var quantity = ''.obs;
  var errorText =''.obs;
  late final  TextEditingController quantityController;
  @override
  void onReady() {


  }

  @override
  void onInit() {
    super.onInit();
    quantityController = TextEditingController();
  }
  @override
  void onClose() {
    quantityController.dispose(); // Dispose the controller to prevent memory leaks
    super.onClose();
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
