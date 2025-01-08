import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';

import '../models/Users.dart';
import '../models/user_singleton.dart';

class   SettingsController extends GetxController {
  var users = Rx<Result<Users>>(Result.initial());

  Future<void> fetchUser(String userId) async {
    Users? user = UserSingleton().getUser();
    log("Fetched user: $user");

    if (user != null) {
      users.value = Result(state: ResultState.SUCCESS, data: user);
    } else {
      users.value = Result(state: ResultState.ERROR, message: "User not found");
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
