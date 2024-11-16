
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/screens/user_view.dart';
import '../config/constants.dart';
import '../generated/assets.dart';

class WarrantyView extends StatelessWidget {
  const WarrantyView({super.key});
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon :Icon(Icons.arrow_back_ios), onPressed: () {
              Get.back();
            },),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    Assets.assetsLogoImage, // Replace with your image path
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      buidPhoneDetailse('1','isar'),
                      buildForm(context),
                      const SizedBox(height: 80,)
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: ImagineColors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                    child:


                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                          padding: EdgeInsets.zero,
                          backgroundColor: ImagineColors.white,
                          textStyle: TextStyle(color: ImagineColors.black),
                        ),
                        onPressed: () {},
                        child: Text('Submit',style: TextStyle(color: ImagineColors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                  ))
            ],
          ),
        ));
  }
  Widget buildForm(BuildContext context) {
    return Form(
        child: Column(

          children: [
            Text('Customer Details'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                minLines: 3,
                maxLines: 6,
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(

                  ),
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),


          ],
        ));
  }

}
