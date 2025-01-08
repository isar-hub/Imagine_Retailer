import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/controller/UserViewController.dart';
import 'package:imagine_retailer/models/Product.dart';
import 'package:imagine_retailer/screens/home_activity.dart';
import 'package:imagine_retailer/screens/widgets/Header.dart';
import 'package:imagine_retailer/screens/widgets/SubmitButton.dart';
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

    List<Widget> children(BuildContext context) => [
          buildProductInformation(controller.product),
          buildCustomerDetails(context),
          const SizedBox(
            height: 80,
          )
        ];

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAll(HomeActivity());
                  });
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
              final result = controller.saveCustomer.value;
              log(controller.saveCustomer.value.state.toString());
              switch (result.state) {
                case ResultState.SUCCESS:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.off(HomeActivity());
                  });
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  );
                case ResultState.ERROR:
                  return Center(
                    child: Text(result.message!),
                  );
                case ResultState.LOADING:
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                case ResultState.INITIAL:
                  return stackChild(children(context));
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
            const Divider(),
            buildHeader('Add Customer Details', color: Colors.white),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            AddressPicker(
                selectedState: (state) {
                  controller.state.value = state;
                },
                selectedCountry: (selectedCountry) {},
                selectedCity: (selectedCity) {
                  controller.city.value = selectedCity;
                }
                ),
          ],
        ));
  }
}

Widget buildProductInformation(Product product) => Card(
      color: Colors.white,
      child: ExpansionTile(
        title: buildHeader(
          'Product Information',
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.red,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProductInfoRow('Serial Number', product.serialNumber),
                buildProductInfoRow('Brand', product.brand),
                buildProductInfoRow('Model', product.model),
                buildProductInfoRow('Variant', product.variant),
                buildProductInfoRow('Condition', product.condition),
                buildProductInfoRow('Selling Price', '₹ ${product.sellingPrice}'),
                // buildProductInfoRow('Status', product.status.billed.toString()),
              ],
            ),
          ),
        ],
      ),
    );
Widget buildProductInfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    ),
  );
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
