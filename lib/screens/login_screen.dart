import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/screens/widgets/btn_getStarted.dart';
import 'package:imagine_retailer/screens/widgets/email_field.dart';
import 'package:imagine_retailer/screens/widgets/error_page.dart';
import '../config/ResultState.dart';
import '../controller/LoginController.dart';

class LoginScreen extends GetView<LoginController>{

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Obx((){
          final loginState = controller.loginState.value;

          log(loginState.state.toString());
          if (loginState.state == ResultState.LOADING) {
            // Show loader during the loading state
            return Center(
              child: CircularProgressIndicator(color: ImagineColors.black,),
            );
          }
          if(loginState.state == ResultState.ERROR){
            return ErrorPage(loginState.message, onHomePressed: () {
              Get.offAll(LoginScreen());
            },);

          }

          return  Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: 1, end: controller.elementsOpacity.value),
                    builder: (_, value, __) => Opacity(
                      opacity: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.flutter_dash,
                              size: 60, color: Colors.white70),
                          const SizedBox(height: 25),
                          const Text(
                            "Welcome,",
                            style: TextStyle(
                                color: Colors.white, fontSize: 35),
                          ),
                          Text(
                            "Sign in to continue",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 35,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        EmailField(
                          fadeEmail: controller.elementsOpacity.value == 0,
                          emailController: controller.emailController,
                          iconData: Icons.perm_identity,


                        ),
                        const SizedBox(height: 40),
                        PasswordField(
                          fadePassword: controller.elementsOpacity.value == 0,
                          passwordController: controller.passwordController,
                          iconData: Icons.password,
                        ),
                        const SizedBox(height: 60),
                        GetStartedButton(
                          elementsOpacity: controller.elementsOpacity.value,
                          onTap: () {
                            controller.elementsOpacity.value = 0;
                            controller.userLogin();
                          },
                          onAnimatinoEnd: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            controller.loadingBallAppear.value = true;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })



      ),
    );
  }
}