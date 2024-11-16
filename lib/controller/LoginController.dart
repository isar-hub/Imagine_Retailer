import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/routes/app_pages.dart';
import 'package:imagine_retailer/screens/home_activity.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var elementsOpacity = 1.0.obs;
  var loadingBallAppear = false.obs;
  var loadingBallSize = 1.obs;

  var auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();



  }

  @override
  void onReady() {
    super.onReady();
    isLoggedIn();
  }
  void isLoggedIn(){
    if(auth.currentUser != null){
      Get.to(()=>HomeActivity(), arguments: auth.currentUser);
    }
  }


  Future<void> userLogin() async {
    var emailAddress = emailController.text.toString();
    var password = passwordController.text.toString();
    try {
       final credential = await auth.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
       showSuccess("${credential.user!.email}");
       Get.off(HomeActivity(), arguments: credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showError("Invalid Credentials");
        print('Invalid Credentials.');
      } else if (e.code == 'wrong-password') {
        showError("Wrong password provided for that user.");
        print('Wrong password provided for that user.');
      }
      else{
        showError("$e");
      }
    }
  }
}
