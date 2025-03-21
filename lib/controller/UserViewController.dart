import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/models/Customers.dart';
import 'package:imagine_retailer/models/Product.dart';
import 'package:imagine_retailer/network/FirebaseApi.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../config/ResultState.dart';

class UserViewController extends GetxController {
  final repository = FirebaseApi();
  var image = Rx<XFile?>(null);
  final formKey = GlobalKey<FormState>();
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  var signature = Rx<Uint8List?>(null);

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var addressController = TextEditingController();

  late Product product;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments;
    log(product.toString());
  }

  var state = 'State'.obs;
  var city = ''.obs;

  Future imageToBytes(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    signature.value = byteData!.buffer.asUint8List();
  }

  void validateAndUpload() {
    if (validateForm(
        name: nameController.text,
        email: emailController.text,
        mobile: phoneController.text,
        address: addressController.text,
        state: state.value,
        image: image.value,
        signature: signature.value)) {
      uploadCustomerImageAndSignature();
    } else {
      showError("All Field are mandatory");
    }
  }

  Future<void> uploadCustomerImageAndSignature() async {
    saveCustomer.value = Result.loading();
    try {
      final imageUrl = await repository.uploadImage('customers/image/', image.value!);
      if (imageUrl.state != ResultState.SUCCESS) {
        saveCustomer.value = Result.error("Image upload failed: ${imageUrl.message}");
        return;
      }

      final signatureUrl = await repository.uploadSignature('customers/signature/', signature.value!);
      if (signatureUrl.state != ResultState.SUCCESS) {
        saveCustomer.value = Result.error("Signature upload failed: ${signatureUrl.message}");
        return;
      }

      var customerDetails = getCustomer(imageUrl.data!, signatureUrl.data!);
      print("Customer details: $customerDetails and serial ${product.serialNumber}");
      var result = await repository.saveCustomerDetails(customerDetails, product.serialNumber.toString(),product.transactionId);

      saveCustomer.value = result;
    } on FirebaseException catch (e) {
      saveCustomer.value = Result.error('Firebase Error: ${e.message}');
    } catch (e) {
      saveCustomer.value = Result.error('Unexpected Error: $e');
    }

  }

  var saveCustomer = Rx<Result<String>>(Result.initial());

  CustomerInfo getCustomer(String imgUrl, String signatureUrl) {
    return CustomerInfo(
      warrantyEnded:  Timestamp.fromDate(DateTime.now().add(const Duration(days: 30 * 6))),
      warrantyStarted:Timestamp.now(),
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      retailerSellingPrice: sellingPriceController.text,
      address: '${addressController.text}, $city',
      state: state.value,
      signatureUrl: signatureUrl,
      imageUrl: imgUrl,
    );
  }

  bool validateForm(
      {required String name,
      required String email,
      required String mobile,
      required String address,
      required String state,
      required XFile? image,
      required Uint8List? signature}) {
    if (name.isEmpty ||
        email.isEmpty ||
        (mobile.isEmpty && mobile.length != 10) ||
        address.isEmpty ||
        (state.isEmpty && !getState().contains(state)) ||
        image == null ||
        signature == null) {
      return false;
    }
    return true;
  }
}
