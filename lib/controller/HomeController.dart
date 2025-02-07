import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/CharData.dart';
import 'package:imagine_retailer/models/Product.dart';
import '../models/NotificationModel.dart';

class Homecontroller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;

  var selectedIndex = 0.obs;
  // Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  var products =
      Result<List<Product>>.loading().obs; // Declare as Result<List<Product>>
  var distinctProducts =
      <CharData>[].obs;
  var distinctCondition =
      <CharData>[].obs;// Observable list for distinct products

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchProducts();
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  void fetchProducts() async {
    try {

      _firestore
          .collection('all-products')
          .where('retailerOrDistributorId', isEqualTo: user?.uid)
          .snapshots()
          .listen((snapshot) {
        // Map the documents to Product objects
        var productList = snapshot.docs.map((doc) {
          print('data is ${doc.data()}');
          return Product.fromJson(doc.data());
        }).toList();
        var brandSummary =
            productList.fold<Map<String, int>>({}, (acc, product) {
          acc[product.brand] = (acc[product.brand] ?? 0) + 1;
          return acc;
        });
        var conditionSummary = productList.fold<Map<String, int>>({}, (acc, product) {
          acc[product.condition] = (acc[product.condition] ?? 0) + 1; // Replace 'brand' with 'condition'
          return acc;
        });

        // Create a list of conditions with distinct quantities
        distinctCondition.value = conditionSummary.entries.map((entry) {
          return CharData(  // Assuming you have a ConditionData model
            brand: entry.key,
            quantity: entry.value,
          );
        }).toList();
        // Create a list of products with distinct brands and quantities
        distinctProducts.value = brandSummary.entries.map((entry) {
          return CharData(
            brand: entry.key,
            quantity: entry.value,
          );
        }).toList();

        // Update the products observable list with the Result object
        products.value = Result.success(productList);
      });
    } catch (e) {
      print("Error ${e}");
      // Handle error appropriately
      products.value = Result.error('Error fetching products: $e');
    }
  }

  void fetchNotifications() {
    try {
      _firestore
          .collection('notification')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        notifications.value = snapshot.docs.map((doc) {
          return NotificationModel.fromFirestore(doc.data());
        }).toList();
      });
    } catch (e) {
      log('Error fetching notifications: $e');
    }
  }
}
