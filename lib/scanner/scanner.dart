import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/scanner/scanner_controller.dart';

import '../generated/assets.dart';

class ScannerActivity extends GetView<ScannerController> {
  const ScannerActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(alignment : Alignment.centerRight,child: Image.asset(
            Assets.assetsLogoImage,  // Replace with your image path
            height: 40,
          ),),
        ),

      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///image box container
                Container(
                    height: 220,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child:
                    ///image box scrollview
                    SingleChildScrollView(
                      child: Obx(()=>

                      controller.selectedImagePath.value==''?
                      const Center(child: Text("Select an image from Gallery / camera")):
                      Image.file(
                        File(controller.selectedImagePath.value),
                        width: Get.width,
                        height: 300,
                      ),


                      ),
                    )
                ),
                ///button row
                Container(
                  //margin: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: (){
                        controller.getImage(ImageSource.gallery);
                      }, child: const Text("Pick Image")),
                      ElevatedButton(onPressed: (){
                        controller.recognizedText(controller.selectedImagePath.value);
                      }, child: const Text("Scan")),
                    ],
                  ),
                ),
                ///text box ScrollView
                SingleChildScrollView(
                  child: Container(
                    height: 190,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Obx(()=>

                    controller.extractedBarcode.value.isEmpty?
                    const Center(child: Text("No data found in barcode")):
                    Center(child: Text(controller.extractedBarcode.value))


                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
