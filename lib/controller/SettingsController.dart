import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);
}