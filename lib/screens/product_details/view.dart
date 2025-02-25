import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/models/Customers.dart';
import 'package:imagine_retailer/screens/product_details/cards/customer_info_card.dart';
import 'package:imagine_retailer/screens/product_details/cards/phone_details_card.dart';
import 'package:imagine_retailer/screens/product_details/cards/transaction_flow_card.dart';
import 'package:imagine_retailer/screens/product_details/cards/warranty_info_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/transactions.dart' as t;
import '../../models/Product.dart';
import '../../models/warranty_model.dart';
import 'logic.dart';

class Product_detailsComponent extends StatelessWidget {
  Product_detailsComponent({super.key, required this.productDetails});

  final Product_detailsLogic logic = Get.put(Product_detailsLogic());
  final Product productDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PhoneDetailCard(
              product: productDetails,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("transactions").doc(productDetails.transactionId).get(), // Fetch document
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Skeletonizer(child: TransactionFlowCard(transaction: null,));
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return const Text("No Transaction Available",
                      style: TextStyle(fontWeight: FontWeight.bold));
                }

                // Extract data

                var transactionJson =
                snapshot.data!.data() as Map<String, dynamic>;
                final transaction = t.Transaction.fromJson(transactionJson);

                return TransactionFlowCard(transaction: transaction,);
              },
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("customers").doc(productDetails.serialNumber).get(), // Fetch document
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Skeletonizer(child: CustomerInfoCard(customerInfo: null,));
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null ||
                !snapshot.data!.exists

                ) {
                  return const Text("No Transaction Available",
                      style: TextStyle(fontWeight: FontWeight.bold));
                }

                // Extract data
                if(snapshot.data != null ||  (snapshot.data!.data() is Map)){
                  var customerJson =
                  snapshot.data!.data() as Map<String, dynamic>;
                  final transaction = CustomerInfo.fromJson(customerJson);
                  return CustomerInfoCard(customerInfo: transaction,);
                }
                return const Text("No Customer Available",
                    style: TextStyle(fontWeight: FontWeight.bold));


              },
            ),

            // warranty details
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("warranty").doc(productDetails.serialNumber).get(), // Fetch document
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Skeletonizer(child: WarrantyInfoCard(warranty: null,));
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null ||
                    !snapshot.data!.exists

                ) {
                  return const Text("No Warranties Available",
                      style: TextStyle(fontWeight: FontWeight.bold));
                }

                // Extract data
                final data = snapshot.data!.data();
                if (data is Map<String, dynamic> && data['claims'] != null) {
                  final claimsData = data['claims'] as List<dynamic> ?? [];
                  final warranties = claimsData.map((claim) => Warranty.fromJson(claim as Map<String,dynamic>)).toList();
                  return WarrantyInfoCard(warranty: warranties);
                }
                return const Text("No Customer Available",
                    style: TextStyle(fontWeight: FontWeight.bold));


              },
            ),
          ],
        ),
      ),
    ));
  }
}
