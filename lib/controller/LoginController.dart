import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/routes/app_pages.dart';
import 'package:imagine_retailer/screens/home_activity.dart';
import 'package:imagine_retailer/screens/login_screen.dart';

import '../config/ResultState.dart';
import '../repository/login_repository.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var elementsOpacity = 1.0.obs;
  var loadingBallAppear = false.obs;
  var loadingBallSize = 1.obs;

  final LoginRepository _loginRepository = LoginRepository();
  final loginState = Result<User?>.initial().obs;
  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    print('LoginController initialized, state: ${loginState.value}');
  }

  @override
  void onReady() {
    super.onReady();
    _checkLoggedInStatus();
  }

  void _checkLoggedInStatus() async {
    final currentUser = _loginRepository.getCurrentUser();
    if (currentUser != null) {
      final isRetailer = await _loginRepository.checkUserRole(currentUser.uid);
      if (isRetailer) {
        Get.offAll(() => HomeActivity(), arguments: currentUser);
      } else {
        showError(
            "You do not have the required permissions to access this app.");
        await _loginRepository.signOut();
        if (Get.currentRoute != AppPages.LOGIN) {
          Get.offAllNamed(AppPages.LOGIN);
        }
      }
    } else if (Get.currentRoute != AppPages.LOGIN) {
      Get.offAllNamed(AppPages.LOGIN);
    }
  }

  Future<void> userLogin() async {
    final emailAddress = emailController.text.trim();
    final password = passwordController.text.trim();

    loginState.value = Result.loading(); // Set state to loading
    try {
      final user = await _loginRepository.signInWithEmailAndPassword(
          "$emailAddress@imagine.com", password);
      if (user != null) {
        final isRetailer = await _loginRepository.checkUserRole(user.uid);
        if (isRetailer) {
          loginState.value = Result.success(user); // Set state to success
          Get.offAll(() => HomeActivity(), arguments: user);
        } else {
          _loginRepository.signOut();
          loginState.value = Result.error(
              "You do not have the required permissions to access this app.");
        }
      }
    } catch (e) {
      loginState.value = Result.error(e.toString()); // Set state to error
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
