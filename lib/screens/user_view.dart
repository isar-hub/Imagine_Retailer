import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/controller/UserViewController.dart';
import 'package:imagine_retailer/screens/warranty_view.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../generated/assets.dart';

class UserView extends GetView<UserViewController> {
  UserView({super.key});

  @override
  Widget build(BuildContext context) {
    // var map = Get.arguments as Map<String, String>;
    // var quantity = map['quantity'];
    // var name = map['brand'];
    var quantity = '1';
    var name = 'samsung';
    Get.lazyPut(() => UserViewController());
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon :Icon(Icons.arrow_back_ios), onPressed: () {
          Get.back();
        },),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                Assets.assetsLogoImage, // Replace with your image path
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  buidPhoneDetailse(name!, quantity!),
                  buildCustomerDetails(context),
                  SizedBox(height: 80,)
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                color: ImagineColors.black,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                child:


                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: ImagineColors.white,
                        textStyle: TextStyle(color: ImagineColors.black),
                    ),
                    onPressed: () {
                      Get.to(WarrantyView());
                    },
                    child: Text('Submit',style: TextStyle(color: ImagineColors.black,fontSize: 20,fontWeight: ui.FontWeight.bold),)),
              ))
        ],
      ),
    ));
  }

  Widget buildCustomerDetails(BuildContext context) {
    return Column(
      children: [
        buildForm(context),
        buildCameraAndSignature(context),
      ],
    );
  }

  Widget buildCameraAndSignature(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Signature Section
        Text('Customer Signature', style: TextStyle(fontSize: 16)),
        Obx(() {
          return controller.signature.value != null
              ? _buildSignatureContainer(
                  controller.signature.value!, 'Signature')
              : _buildPlaceholder('Please Add Signature');
        }),
        _buildButton(
          context,
          'Add Signature',
          () => Get.bottomSheet(
            BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OutlinedButton(
                        child: const Text("Done",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          controller.imageToBytes(await controller
                              .signaturePadKey.currentState!
                              .toImage());
                          Get.back();
                        },
                      ),
                    ),
                    SfSignaturePad(
                      key: controller.signaturePadKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Photo Section
        Text('Customer Photo', style: TextStyle(fontSize: 16)),
        Obx(() {
          return controller.image.value != null
              ? _buildImageContainer(controller.image.value!, 'Photo')
              : _buildPlaceholder('No Image Selected');
        }),
        _buildButton(
          context,
          'Add Photo',
          () => Get.bottomSheet(
            BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () {
                        controller.pickImage(ImageSource.camera);
                        Get.back();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Gallery'),
                      onTap: () {
                        controller.pickImage(ImageSource.gallery);
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

// Helper Widget: Image Container
  Widget _buildImageContainer(File imageFile, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(width: 2, color: Colors.white),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Image.file(
        imageFile,
        height: 200,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSignatureContainer(Uint8List imageFile, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(width: 2, color: Colors.white),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Image.memory(
        imageFile,
        height: 200,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

// Helper Widget: Placeholder Container
  Widget _buildPlaceholder(String message) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(width: 2, color: Colors.white),
      ),
      child: Center(child: Text(message)),
    );
  }

// Helper Widget: Elevated Button
  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ImagineColors.white,
        textStyle: TextStyle(color: ImagineColors.black),
      ),
      child: Text(label, style: TextStyle(color: ImagineColors.black)),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(

        key: controller.formKey,
        child: Column(

          children: [
            Text('Customer Details'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ImagineColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.zero, // Remove internal padding
              ),
              onPressed: () {
                _showDialog(
                    CupertinoPicker(
                      backgroundColor: Colors.transparent,
                      looping: true,
                      itemExtent: 40,
                      // This sets the initial item.
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.indianStatesAndUTs
                            .indexOf(controller.state.value),
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        controller.state.value =
                            controller.indianStatesAndUTs[selectedItem];
                      },

                      children: List<Widget>.generate(
                          controller.indianStatesAndUTs.length, (int index) {
                        return Center(
                            child: Text(
                          controller.indianStatesAndUTs[index],
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.black),
                        ));
                      }),
                    ),
                    context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      controller.state.value,
                      style:
                          const TextStyle(fontSize: 22.0, color: Colors.black),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ImagineColors.black,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: Colors.white,
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}

Widget buidPhoneDetailse(String brand, String quantity) {
  return ListTile(
    title: Text(brand),
    subtitle: Text(brand),
    isThreeLine: true,
  );
}
