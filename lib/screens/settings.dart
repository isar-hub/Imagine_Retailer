import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/Users.dart';
import 'package:imagine_retailer/screens/widgets/display_image.dart';

import '../controller/SettingsController.dart';
import 'edit_profile.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller once during page initialization
    Get.lazyPut(() => SettingsController());

    return Scaffold(
      body: Obx((){
        final result = controller.users.value;
        switch(result.state){

          case ResultState.SUCCESS: return buildUserNotEmpty(result.data!);

          case ResultState.ERROR:  return Center(child: Text(result.message ?? 'Error occurred'));

          case ResultState.LOADING:return Center(child: CircularProgressIndicator());

        }
      })
    );
  }

  Widget buildUserNotEmpty(Users user)=> Column(
    children: [
      buildUserInfoSection(user),
      buildButton('SignOut', Icons.logout,user),
    ],
  );
  // Button widget with SignOut functionality
  Widget buildButton(String text, IconData icon,Users user) => SettingsCard(
    [
      Expanded(flex: 4, child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
      )),
      Expanded(
        child: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut(); // Implement SignOut functionality here
            Get.offAllNamed('/login'); // Navigate to the login screen after sign out (adjust based on your navigation setup)
          },
          icon: Icon(icon, color: Colors.black),
        ),
      ),
    ],
    user
  );

  // User Info Section with Profile Image and Display Name
  Widget buildUserInfoSection(Users user) {
    return SettingsCard(
      [
        Expanded(
          child: DisplayImage(
            imagePath: user.image  ??
                "https://avatar.iran.liara.run/username?username=${user.name ?? 'Guest'}",
            onPressed: () {},
          ),
        ),
        Expanded(
          flex: 4,
          child: buildUserInfoDisplay(user),
        ),
      ],
      user
    );
  }

  // Display Name and Arrow icon widget
  Widget buildUserInfoDisplay(Users user) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Text(
          user.name ?? 'Guest',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        Spacer(),
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 40.0),
      ],
    ),
  );

  // SettingsCard widget with tap functionality to navigate to EditProfile screen
  Widget SettingsCard(List<Widget> children,Users user) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        Get.to( EditProfile(user: user,));
      },
      child: Card(
        color: Colors.white,
        child: Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    ),
  );

  // About section, displaying user's creation date
  Widget buildAbout(User user) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell Us About Yourself',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 1),
          Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          user.metadata.creationTime?.toString() ?? 'Unknown', // Handle null safely
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}