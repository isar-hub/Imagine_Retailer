import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/controller/UserViewController.dart';
import 'package:imagine_retailer/screens/widgets/address_picker.dart';
import 'package:imagine_retailer/screens/widgets/body_with_btn.dart';
import 'package:imagine_retailer/screens/widgets/common_text_field.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../generated/assets.dart';

class UserView extends GetView<UserViewController> {
  UserView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserViewController());

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),
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
            body: SubmitButtonBody(
                children: children(context), stackChild: stackChild())));
  }

  List<Widget> children(BuildContext context) => [
        buidPhoneDetailse("name", "quantity"),
        buildCustomerDetails(context),
        const SizedBox(
          height: 80,
        )
      ];
  Widget stackChild() {
    return Obx(() {
      final result = controller.saveCustomer.value;
      switch (result.state) {
        case ResultState.SUCCESS:
          {
            showSuccess(result.data!);
            Get.back();
            return CircularProgressIndicator();
          }

        case ResultState.ERROR:
          showError(result.message!);
          return ElevatedButton(
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
                controller.validateAndUpload();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                    color: ImagineColors.black,
                    fontSize: 20,
                    fontWeight: ui.FontWeight.bold),
              ));
        case ResultState.LOADING:
          {
            return CircularProgressIndicator();
          }

        case ResultState.INITIAL:
          {
            return ElevatedButton(
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
                  controller.validateAndUpload();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: ImagineColors.black,
                      fontSize: 20,
                      fontWeight: ui.FontWeight.bold),
                ));
          }
      }
    });
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
              : buildPlaceholder('Please Add Signature');
        }),
        _buildSignatureBtn(),
        const SizedBox(height: 20),
        Text('Customer Photo', style: TextStyle(fontSize: 16)),
        Obx(() {
          return controller.image.value != null
              ? buildImageContainer(controller.image.value!, 'Photo')
              : buildPlaceholder('No Image Selected');
        }),
        _buildButton(),
      ],
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

  Widget _buildSignatureBtn() {
    return ElevatedButton(
      onPressed: () async {
        await Get.bottomSheet(
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
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ImagineColors.white,
        textStyle: TextStyle(color: ImagineColors.black),
      ),
      child:
          Text('Add Signature', style: TextStyle(color: ImagineColors.black)),
    );
  }

// Helper Widget: Elevated Button
  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () => Get.bottomSheet(
        BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    controller.image.value =
                        await pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () async {
                    controller.image.value =
                        await pickImage(ImageSource.gallery);
                  },
                ),
              ],
            );
          },
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ImagineColors.white,
        textStyle: TextStyle(color: ImagineColors.black),
      ),
      child: Text('Add Photo', style: TextStyle(color: ImagineColors.black)),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Column(
          children: [
            Text('Add Customer Details'),
            SizedBox(height: 20),
            CommonTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              emailController: controller.nameController,
              label: 'Name',
              iconData: Icons.person_pin_outlined,
            ),
            SizedBox(height: 20),
            CommonTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              emailController: controller.phoneController,
              label: 'Phone',
              iconData: Icons.phone,
            ),
            SizedBox(height: 20),
            CommonTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              emailController: controller.emailController,
              label: 'Email',
              iconData: Icons.email_outlined,
            ),
            SizedBox(height: 20),
            CommonTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              emailController: controller.sellingPriceController,
              label: 'Selling Price',
              iconData: Icons.currency_rupee_outlined,
            ),
            SizedBox(height: 20),
            CommonTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              maxLines: 5,
              emailController: controller.addressController,
              label: 'Address',
              iconData: Icons.location_on,
            ),
            SizedBox(height: 20),
            AddressPicker(
                selectedState: (state) {
                  controller.state.value = state;
                },
                selectedCountry: (selectedCountry) {},
                isCity: false,
                selectedCity: (selectedCity) {}),
          ],
        ));
  }
}

// Helper Widget: Image Container
Widget buildImageContainer(XFile imageFile, String label) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      border: Border.all(width: 2, color: Colors.white),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Image.file(
      File(imageFile.path),
      height: 200,
      width: double.infinity,
      fit: BoxFit.contain,
    ),
  );
}

Widget buidPhoneDetailse(String brand, String quantity) {
  return ListTile(
    title: Text(brand),
    subtitle: Text(brand),
    isThreeLine: true,
  );
}
Widget buildPlaceholder(String message) {
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
