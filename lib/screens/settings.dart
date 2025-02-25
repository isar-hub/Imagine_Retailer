import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/models/Users.dart';
import 'package:imagine_retailer/screens/login_screen.dart';
import 'package:imagine_retailer/screens/transaction_page/view.dart';
import 'package:imagine_retailer/screens/widgets/display_image.dart';

import '../controller/SettingsController.dart';
import '../routes/app_pages.dart';
import 'edit_profile.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller once during page initialization
    Get.lazyPut(() => SettingsController());

    return Scaffold(body: Obx(() {
      final result = controller.users.value;
      switch (result.state) {
        case ResultState.INITIAL:
        case ResultState.SUCCESS:
          return buildUserNotEmpty(result.data!);

        case ResultState.ERROR:
          return Center(child: Text(result.message ?? 'Error occurred'));

        case ResultState.LOADING:
          return const Center(child: CircularProgressIndicator());
      }
    }));
  }

  Widget buildUserNotEmpty(Users user) => Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Get.to(EditProfile(
              user: user,
            )),
            child: buildUserInfoSection(user),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Get.to(() => Transaction_pageComponent(
                  user: user,
                )),
            child: buildTraButton('Transactions', Icons.history, user),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAllNamed(AppPages.LOGIN);
            },
            child: buildButton('SignOut', Icons.logout, user),
          ),
        ],
      );

  // Button widget with SignOut functionality
  Widget buildButton(String text, IconData icon, Users user) => SettingsCard([
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            )),
        Expanded(
          child: IconButton(
            onPressed: () {
              FirebaseAuth.instance
                  .signOut(); // Implement SignOut functionality here
              Get.offAll(LoginScreen());
            },
            icon: Icon(icon, color: Colors.black),
          ),
        ),
      ], user);
  Widget buildTraButton(String text, IconData icon, Users user) =>
      SettingsCard([
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            )),
        Expanded(
          child: IconButton(
            onPressed: () {
              Get.to(() => Transaction_pageComponent(
                    user: user,
                  ));
            },
            icon: Icon(icon, color: Colors.black),
          ),
        ),
      ], user);

  // User Info Section with Profile Image and Display Name
  Widget buildUserInfoSection(Users user) {
    final imagePath = (user.image != null && user.image!.isNotEmpty)
        ? user.image!
        : "https://avatar.iran.liara.run/username?username=${user.name ?? 'Guest'}";
    return SettingsCard([
      Expanded(
        child: DisplayImage(
          imagePath: imagePath,
          onPressed: () {
            Get.to(EditProfile(
              user: user,
            ));
          },
        ),
      ),
      Expanded(
        flex: 4,
        child: buildUserInfoDisplay(user),
      ),
    ], user);
  }

  // Display Name and Arrow icon widget
  Widget buildUserInfoDisplay(Users user) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              user.name ?? 'Guest',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_right,
                color: Colors.grey, size: 40.0),
          ],
        ),
      );

  // SettingsCard widget with tap functionality to navigate to EditProfile screen
  Widget SettingsCard(List<Widget> children, Users user) => Card(
        color: Colors.white,
        child: Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      );

  // About section, displaying user's creation date
  Widget buildAbout(User user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell Us About Yourself',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 1),
          Container(
            width: 350,
            height: 200,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          user.metadata.creationTime?.toString() ?? 'Unknown',
                          // Handle null safely
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right,
                    color: Colors.grey, size: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
