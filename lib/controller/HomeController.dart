import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/NotificationModel.dart';

class Homecontroller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var selectedIndex = 0.obs;
  // Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }
  void onItemTapped(int index) {
    selectedIndex.value = index;
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
