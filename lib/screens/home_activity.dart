import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/controller/HomeController.dart';
import 'package:imagine_retailer/generated/assets.dart';
import 'package:imagine_retailer/screens/barcode_view.dart';
import 'package:imagine_retailer/screens/notification_view.dart';
import 'package:imagine_retailer/screens/settings.dart';

import '../scanner/mlkit_scanner/barcode_scanner.dart';
import 'dashboard.dart';

class HomeActivity extends GetView<Homecontroller> {
  List<Widget> pages = [DashboardPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    var notificationCount = 05;
    Get.lazyPut(() => Homecontroller());

    return SafeArea(
      child: Obx(() {
        return Scaffold(
          body: pages[controller.selectedIndex.value],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeView(),
                ),
              );
            },
            tooltip: "Scanner",
            child: const Icon(
              Icons.qr_code_scanner_outlined,
              color: Colors.black,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Assets.assetsLogoImage, // Replace with your image path
                  height: 40,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap:()=> Get.to(const NotificationView()) ,
                child: buildNotificationIcon(),
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 10,
            clipBehavior: Clip.antiAlias,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Padding for better spacing
                child: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard), label: 'Dashboard'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.more_horiz_outlined),
                        label: 'Settings'),
                  ],
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.onItemTapped,
                  // Handle tap events
                  type: BottomNavigationBarType.fixed,
                )),
          ),
        );
      }),
    );
  }

  Widget buildNotificationIcon()=>Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ImagineColors.red,
      ),
      child: Obx(() {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (controller.notifications
                .isNotEmpty) // Check if there's a count to display
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  height: 10,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ImagineColors
                        .red, // Background color of the count badge
                  ),
                ),
              ),
            const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ],
        );
      }),
    ),
  );
}
