import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/models/Product.dart';
import 'package:imagine_retailer/repository/barcode_repository.dart';

import '../screens/user_view.dart';

class BarCodeController extends GetxController {


  var product = Rx<Result<Product>>(Result.loading());
  BarcodeRepository repository = BarcodeRepository();
  Rx<bool> isLoading = false.obs;
  Rx<bool> isBarCode = true.obs;
  @override
  void onReady() {
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    // quantityController.dispose();
    super.onClose();
  }

  Future fetchProduct(String serialNumber)async{
    final result = await repository.fetchProduct(serialNumber);
    product.value = result;
    switch(result.state){

      case ResultState.SUCCESS:
        isLoading.value = false;
        Get.to(()=>UserView(),arguments: result.data);
      case ResultState.ERROR:
        isLoading.value = false;

        showError(result.message!);
      case ResultState.LOADING:
        isLoading.value = true;
      case ResultState.INITIAL:

    }

  }
}
