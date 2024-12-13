import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/screens/warranty_view.dart';

import '../../controller/controllers.dart';
import '../../models/Product.dart';
import '../../screens/user_view.dart';

class BarcodeView extends GetView<BarCodeController> {
  const BarcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BarCodeController());
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          final resultProduct = controller.product.value;
          switch (resultProduct.state) {
            case ResultState.SUCCESS:
              final product = resultProduct.data!;
              if (controller.barCode.toString() ==
                  product.serialNumber.toString()) {
                final targetView = (product.status == ProductStatus.BILLED)
                    ? UserView()
                    : (product.status == ProductStatus.SOLD)
                        ? WarrantyView()
                        : null;

                if (targetView != null) {

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAll(targetView, arguments: product);
                  });

                } else {
                  return const Center(child: Text('Invalid product.'));
                }
              } else {
                return const Center(child: Text('Invalid product.'));
              }
              break;
            case ResultState.ERROR:
              return Center(
                child: Text(
                    'Error retrieving product data. ${resultProduct.message}'),
              );

            case ResultState.LOADING:
            case ResultState.INITIAL:
              return CircularProgressIndicator();
          }

          return const SizedBox.shrink();
        }),
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
            child: Obx(() {
              return ElevatedButton(
                onPressed: controller.errorText.value.isEmpty ? () {} : null,
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
            }),
          ),
        ],
      ),
    );
  }
}
