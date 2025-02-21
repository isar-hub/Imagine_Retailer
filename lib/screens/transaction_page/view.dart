import 'package:easy_refresh/easy_refresh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/models/Users.dart';
import 'package:imagine_retailer/screens/transaction_page/components/transaction_card.dart';

import '../../generated/assets.dart';
import 'logic.dart';

class Transaction_pageComponent extends StatelessWidget {
  Transaction_pageComponent({Key? key, required this.user}) : super(key: key);

  final Users user;
  final Transaction_pageLogic controller = Get.put(Transaction_pageLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selling Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.filterTransactions,
                      focusNode: controller.searchFocusNode,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: controller.clearSearch,
                    splashRadius: 24,
                    tooltip: 'Clear search',
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            ...[
              Obx(() {
                return Text(controller.error.value,
                    style: const TextStyle(color: Colors.red));
              }),
            ],
            // Data Table
            Expanded(
              child: Obx(() {
                return EasyRefresh(
                  onRefresh: () {
                    controller.fetchTransactions();
                  },
                  child: ListView.builder(
                    itemCount: controller.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final row = controller.filteredTransactions[index];
                      // print(
                      //     "Index: $index, Serial Numbers: ${row.serialNumbers.length}, isEmpty: ${row.serialNumbers.isEmpty}");
                      if (controller.isLoading.value) {
                        return Image.asset(Assets.assetsLoaderImagine);
                      }
                      return TransactionReceipt(
                        transaction: row,
                        user: user,
                        onTapSerial: (serial) {
                          controller.fetchProduct(serial);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
