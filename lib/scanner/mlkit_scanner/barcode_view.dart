import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/routes/app_pages.dart';

import '../../controller/controllers.dart';

class BarcodeView extends GetView<BarCodeController> {
  const BarcodeView({super.key, required this.barCode});

  final Barcode barCode;

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(() => BarCodeController());

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: _showPicker(context),
        ),
      ),
    );
  }

  Widget _showPicker(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: ImagineColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Icon and Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Colors.blue,
                  size: 30,
                ),
                Text(
                  'Samsing m32',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ImagineColors.red),
                ),
              ],
            ),
          ),
          Text(
            'Enter Quantity',
            style: TextStyle(color: ImagineColors.red),
          ),
           TextField(
                 controller: controller.quantityController,
                 keyboardType: TextInputType.number,
                 decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: 'Enter quantity',
                 ),

                 onChanged: (value) {
                   controller.quantity.value = value;
                   controller.validateInput(value);
                 },
               ),

          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
               () {
                 return ElevatedButton(
                   onPressed: controller.errorText.value.isEmpty
                       ? () {
                     Get.offNamed(AppPages.USER,
                       arguments: {
                         'quantity': controller.quantity.value,
                         'brand': 'Samsung M32', // Example of using Barcode data
                       },
                     );
                   }
                       : null,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: ImagineColors.red,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                   ),
                   child: Text(
                     'Done',
                     style: TextStyle(
                       color: ImagineColors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 );
              }
            ),
          ),

        ],
      ),
    );  
  }

}
