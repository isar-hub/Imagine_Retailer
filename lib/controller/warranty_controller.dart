import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/models/warranty_model.dart';
import 'package:imagine_retailer/repository/warranty_repository.dart';
import 'package:uuid/uuid.dart';

import '../config/ResultState.dart';
import '../config/common_methods.dart';
import '../models/Product.dart';
import '../network/FirebaseApi.dart';

class WarrantyController extends GetxController {
  final repository = FirebaseApi();
  final warrantyRepo = WarrantyRepository();
  var reasonController = TextEditingController();
  var reasonDescriptionController = TextEditingController();
  var invoiceImage = Rx<XFile?>(null);
  var productImages = Rx<List<XFile>?>(null);

  void deleteProductImage(int index) {
    productImages.value?.removeAt(index);
    productImages.refresh(); // Notify the UI of changes
  }

  void addMore(List<XFile> images) async {
    productImages.value?.addAll(images);
    productImages.refresh();
  }

  late Product product;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments;
  }

  Future<void> validateAndUpload() async {
    if (validateForm(
      reason: reasonController.text,
      description: reasonDescriptionController.text,
      invoiceImage: invoiceImage.value,
      productImage: productImages.value,
    )) {
      try {
        await updateWarranty();
      } catch (e) {
        updateWarrantyState.value = Result.error('Unexpected Error: $e');
      }
    } else {
      showError("All fields are mandatory");
    }
  }

  var updateWarrantyState = Rx<Result<String>>(Result.initial());
  final Uuid uuid = const Uuid();

  Warranty getWarranty(List<String> urls) => Warranty(
      id: uuid.v4(),
      reason: reasonController.text,
      reasonDescription: reasonDescriptionController.text,
      images: urls,
      createdAt: Timestamp.now()
  );

  Future<void> updateWarranty() async {
    updateWarrantyState.value = Result.loading();

// Check if warranty can be claimed
    if (!await warrantyRepo.canClaimWarranty(product.serialNumber)) {
      updateWarrantyState.value =
          Result.error('Error: Warranty already claimed or expired');
      return;
    }

    // Add invoice image if provided
    if (invoiceImage.value != null) {
      productImages.value!.add(invoiceImage.value!);
    }

    // Ensure at least one image exists
    if ((productImages.value ?? []).isEmpty) {
      updateWarrantyState.value = Result.error('Error: Please add images');
      return;
    }

    try {
      // Step 1: Upload Images
      final images = await repository.uploadMultipleImage(
        'customers/warranty',
        productImages.value!,
      );

      if (images.state == ResultState.SUCCESS) {
        // Step 2: Generate Warranty Data
        final warranty = getWarranty(images.data!);

        // Step 3: Update Warranty in Backend
        await warrantyRepo.claimWarranty(
            warranty, product.serialNumber.toString());

        // Success State
        updateWarrantyState.value =
            Result.success("Warranty updated successfully");
      } else {
        // Image Upload Error
        updateWarrantyState.value =
            Result.error('Image Upload Error: ${images.message}');
      }
    }
    on FirebaseException catch (e) {
      updateWarrantyState.value = Result.error('Firebase Error: ${e.message}');
    } catch (e) {
      updateWarrantyState.value = Result.error('Unexpected Error: $e');
    }
  }

  bool validateForm({
    required String reason,
    required String description,
    required XFile? invoiceImage,
    required List<XFile>? productImage,
  }) {
    if (reason.isEmpty || description.isEmpty) return false;
    if (invoiceImage == null || productImage == null || productImage.isEmpty) {
      return false;
    }
    return true;
  }
}
