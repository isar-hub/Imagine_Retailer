import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/screens/user_view.dart';
import 'package:imagine_retailer/screens/widgets/SubmitButton.dart';
import 'package:imagine_retailer/screens/widgets/body_with_btn.dart';
import 'package:imagine_retailer/screens/widgets/common_text_field.dart';

import '../config/ResultState.dart';
import '../config/common_methods.dart';
import '../config/constants.dart';
import '../controller/warranty_controller.dart';
import '../generated/assets.dart';

class WarrantyView extends GetView<WarrantyController> {
  const WarrantyView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WarrantyController());
    var children = [
      buidPhoneDetailse('1', 'isar'),
      buildForm(context),
      buildImageSection(),
      buildProductImage(),
      SizedBox(
        height: 80,
      )
    ];

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Get.back();
                },
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
            body: Obx(() {
              final result = controller.updateWarrantyState.value;
              switch (result.state) {
                case ResultState.SUCCESS:
                  {
                    showSuccess(result.data!);
                    Get.back();
                    return CircularProgressIndicator();
                  }

                case ResultState.ERROR:
                  showError(result.message!);
                  return stackChild(children);
                case ResultState.LOADING:
                  {
                    return CircularProgressIndicator();
                  }

                case ResultState.INITIAL:
                  {
                    return stackChild(children);
                  }
              }
            })));
  }

  Widget stackChild(List<Widget> children) =>
      SubmitButtonBody(stackChild: buildSubmitBtn(), children: children);
  Widget buildSubmitBtn() => SubmitButton(
        onPressed: () async {
          controller.validateAndUpload();
        },
      );

  Widget buildForm(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Text('Customer Details'),
        SizedBox(
          height: 20,
        ),
        CommonTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          emailController: controller.reasonController,
          label: 'Please Specify Reason',
          iconData: Icons.broken_image_outlined,
        ),
        SizedBox(
          height: 20,
        ),
        CommonTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          emailController: controller.reasonDescriptionController,
          label: 'Please Specify Reason in Details',
          iconData: Icons.description,
          maxLines: 4,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ));
  }

// Helper Widget: Elevated Button
  Widget _buildButton(String label, {bool isSingleImage = true}) {
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
                    controller.invoiceImage.value =
                        await pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () async {
                    controller.invoiceImage.value =
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
      child: Text(label, style: TextStyle(color: ImagineColors.black)),
    );
  }

  Widget buildButtonProduct() => ElevatedButton(
        onPressed: () async => controller.productImages.value =
            await ImagePicker().pickMultiImage(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ImagineColors.white,
          textStyle: TextStyle(color: ImagineColors.black),
        ),
        child: Text('Add Product Images',
            style: TextStyle(color: ImagineColors.black)),
      );
  Widget buildProductImage() {
    return Obx(() {
      if (controller.productImages.value != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                radius: Radius.circular(100),
                thickness: 5,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.productImages.value!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.productImages.value!.length) {
                        return IconButton(
                          onPressed: () async {
                            controller
                                .addMore(await ImagePicker().pickMultiImage());
                          },
                          tooltip: "Add More",
                          icon: Icon(Icons.add_circle_outline_sharp, size: 30),
                        );
                      }
                      final imageFile = controller.productImages.value?[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            buildImageContainerProduct(
                                imageFile!, "ProductImage$index"),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                  onPressed: () {
                                    controller.deleteProductImage(index);
                                  },
                                  icon: Icon(Icons.delete)),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      } else {
        return Align(
            alignment: Alignment.centerLeft, child: buildButtonProduct());
      }
    });
  }

// Helper Widget: Image Container
  Widget buildImageContainerProduct(XFile imageFile, String label) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(width: 2, color: Colors.white),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Image.file(
        File(imageFile.path),
        height: 200,
        width: 150,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildImageSection() {
    return Obx(() {
      if (controller.invoiceImage.value != null) {
        return Column(
          children: [
            buildImageContainer(controller.invoiceImage.value!, 'Photo'),
            _buildButton('Change Image')
          ],
        );
      } else {
        return Align(
            alignment: Alignment.centerLeft,
            child: _buildButton('Add Invoice'));
      }
    });
  }
}
