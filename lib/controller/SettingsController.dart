import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';

import '../models/Users.dart';

class SettingsController extends GetxController {
  var users = Rx<Result<Users>>(Result.loading());

  Future<void> fetchUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        log('${snapshot.data()}');
        users.value = Result.success(Users.fromJson(snapshot.data()!));


      } else {
        users.value = Result.error("User not found");
        Get.snackbar('Error', 'User not found');
      }
    } catch (e) {
      users.value = Result.error('Failed to fetch user data: $e');
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  var role = "Retailer".obs; // Default role
  var state = "".obs;
  var city = "".obs;
  var country = "".obs;

  @override
  void onInit() async {
    super.onInit();
    fetchUser(FirebaseAuth.instance.currentUser!.uid);
  }

  // Validate the form fields
  bool validateForm({
    required String name,
    required String email,
    required String mobile,
    required String companyName,
    required String gst,
    required String address,
    required String pinCode,
  }) {
    if (name.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        companyName.isEmpty ||
        gst.isEmpty ||
        address.isEmpty ||
        pinCode.isEmpty ||
        state.value.isEmpty ||
        city.value.isEmpty) {
      return false;
    }
    return true;
  }
}
