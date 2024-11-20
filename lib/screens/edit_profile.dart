import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/screens/widgets/address_picker.dart';
import 'package:imagine_retailer/screens/widgets/common_text_field.dart';
import 'package:imagine_retailer/screens/widgets/email_field.dart';

import '../controller/SettingsController.dart';
import '../models/Users.dart';

class EditProfile extends StatelessWidget {

  final Users user;
  const EditProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    // Controllers for form fields
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final mobileController = TextEditingController(text: user.mobile);
    final companyNameController = TextEditingController(text: user.companyName);
    final gstController = TextEditingController(text: user.gstNumber);
    final addressController = TextEditingController(text: user.address);
    final pinCodeController = TextEditingController(text: user.pinCode.toString());
    final passWordController = TextEditingController(text: user.password);
    final cnfrmPasswordController = TextEditingController(text: user.password);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          child: Image.network(
                            fit: BoxFit.fill,
                                "https://avatar.iran.liara.run/username?username=${"isar"}",
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Form fields
                buildTextField("Full Name", nameController, Icons.person_2_outlined),
                buildTextField("Email", emailController, Icons.email_outlined),
                buildTextField("Mobile", mobileController, Icons.phone),
                buildTextField("Company Name", companyNameController,
                    Icons.home_work_outlined),
                buildTextField(
                    "GST Number", gstController, Icons.text_snippet_outlined),
                Divider(),
                buildTextField("Username", nameController, Icons.person),
                buildPassword(passWordController,"Password"),
                buildPassword(cnfrmPasswordController,"Confirm Password"),


                Divider(),

                buildTextField("Address", addressController, Icons.notes_sharp),
                // buildStateDropdown(controller),
                buildTextField(
                  "Pin Code",
                  pinCodeController,
                  Icons.pin_drop_outlined,
                ),
                AddressPicker(
                    selectedState: (state) {},
                    selectedCountry: (selectedCountry) {},
                    selectedCity: (selectedCity) {}),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    if (controller.validateForm(
                      name: nameController.text,
                      email: emailController.text,
                      mobile: mobileController.text,
                      companyName: companyNameController.text,
                      gst: gstController.text,
                      address: addressController.text,
                      pinCode: pinCodeController.text,
                    )) {
                      // Handle save action here
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill all the fields.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text("Save",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build state dropdown


  Widget buildPassword(TextEditingController textController,String hinttext){
    return Padding(padding: EdgeInsets.symmetric(vertical: 10),
    child: PasswordField(passwordController: textController, fadePassword: false,iconData: Icons.lock_clock_sharp,hintText: hinttext,),
    );
  }

  // Helper method to build text form fields
  Widget buildTextField(
      String label, TextEditingController textController, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CommonTextField(
        emailController: textController,
        label: label,
        iconData: icon,
      ),
    );
  }
}
