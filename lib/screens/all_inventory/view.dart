import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/controller/HomeController.dart';
import 'package:imagine_retailer/models/Product.dart';

import '../../generated/assets.dart';
import 'logic.dart';

class All_inventoryComponent extends StatelessWidget {
  final All_inventoryLogic logic = Get.put(All_inventoryLogic());

  final List<Product> product;
  final bool isLoading;
  final Homecontroller controller = Get.find();
  All_inventoryComponent(
      {super.key, required this.product, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: Image.asset(Assets.assetsInventory,height: double.infinity,),
        appBar: AppBar(
          title: Text('Inventory'),
        ),
        body: EasyRefresh(
          onRefresh: () {
            controller.fetchProducts();
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                )
              : product.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: product[index]);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mobile_friendly_rounded,
                              size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text(
                            "No products available",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
        // body: ListView(
        //
        //   children: product.isNotEmpty
        //       ? product.map((item) => ProductCard(product: item)).toList()
        //       : [const Center(child: Text("No products available",style: TextStyle(color: Colors.black),))], // Show message if empty
        // ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'silver':
        return Colors.grey;
      case 'gold':
        return Colors.yellow;
      case 'platinum':
        return Colors.black38;
      default:
        return Colors.blue; // Default status color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${product.brand} ${product.model}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle status click
                  Get.snackbar("Status", "Current status: ${product.condition}");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(product.condition).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.condition.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Product Variant & IMEI Numbers
          Text(
            product.variant,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'IMEI1: ${product.imei_1}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            'IMEI2: ${product.imei_2}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            'S/N: ${product.serialNumber}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),

          // Clickable Transaction ID
          GestureDetector(
            onTap: () {
              // Handle transaction ID click
              Get.snackbar("Transaction ID", "Transaction ID: ${product.transactionId}");
            },
            child: Row(
              children: [
                const Icon(Icons.payment, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Transaction ID: ${product.transactionId}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Price & Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '₹${product.retailerPrice}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough, // Strike-through price
                    color: Colors.red, // Discounted price color
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle button click
                    // Get.to(() => ProductDetailsScreen(product: product));
                  },
                  label: const Text(
                    'Details',
                    style: TextStyle(fontSize: 10),
                  ),
                  icon: const Icon(Icons.arrow_forward_ios_sharp, size: 14),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

