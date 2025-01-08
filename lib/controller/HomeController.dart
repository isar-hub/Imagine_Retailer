import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/Product.dart';
import '../models/NotificationModel.dart';

class Homecontroller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;

  var selectedIndex = 0.obs;
  // Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  var products = Result<List<Product>>.loading().obs; // Declare as Result<List<Product>>

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchProducts();

  }
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }


  void fetchProducts() {
    try {

      _firestore.collection('all-products')
          .where('retailerOrDistributorId', isEqualTo: user?.uid)
          .snapshots()
          .listen((snapshot) {
        // Map the documents to Product objects
        var productList = snapshot.docs.map((doc) {
          return Product.fromJson(doc.data());
        }).toList();

        // Update the products observable list with the Result object
        products.value = Result.success(productList);
      });
    } catch (e) {
      // Handle error appropriately
      products.value = Result.error('Error fetching products: $e');
    }
  }

  void fetchNotifications() {
    try{
      _firestore
          .collection('notification')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        notifications.value = snapshot.docs.map((doc) {
          return NotificationModel.fromFirestore(doc.data());
        }).toList();
      });

    }
    catch(e){
      log('Error fetching notifications: $e');
    }

  }
}
