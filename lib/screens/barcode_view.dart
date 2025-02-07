import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/screens/warranty_view.dart';
import 'package:imagine_retailer/screens/widgets/common_text_field.dart';

import '../controller/controllers.dart';
import '../models/Product.dart';
import '../scanner/mlkit_scanner/barcode_scanner.dart';
import 'user_view.dart';

class BarcodeView extends GetView<BarCodeController> {
  const BarcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BarCodeController());
    final TextEditingController barcodeController = TextEditingController();

    void openScanner() async {
      final result = await Get.to(() => const BarcodeScannerView());
      if (result != null) {
        controller.isBarCode.value = true;
        barcodeController.text =  result;
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner Parent'),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return Center(child: CircularProgressIndicator(color: ImagineColors.black,),);
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextField(
                emailController: barcodeController,
                label: 'Scanned Barcode',
                iconData: controller.isBarCode.value ? Icons.search : Icons
                    .camera_alt,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Open Scanner'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50), // Set a fixed width for the button
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: openScanner, // Open the scanner on press
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50), // Set a fixed width for the button
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: controller.isBarCode.value
                        ? () {
                      controller.fetchProduct(barcodeController.text);

                    }
                        : null, // Disable the button if no barcode is scanned
                  ),
                ],
              ),
            ],
          ),
        );

      })



    );
  }
}
