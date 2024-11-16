import 'package:flutter/material.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/generated/assets.dart';
import 'package:imagine_retailer/screens/settings.dart';

import '../scanner/mlkit_scanner/barcode_scanner.dart';
import 'dashboard.dart';

class HomeActivity extends StatefulWidget {
   const HomeActivity({super.key});

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  int _selectedIndex = 0;

   void _onItemTapped(int index) {
     setState(() {
       _selectedIndex = index; // Update the selected index
     });
   }

  List<Widget> pages =  [
    const DashboardPage(),
    const SettingsPage()

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BarcodeScannerView(),
              ),
            );
          },

          tooltip: "Scanner",
          child: const Icon(Icons.qr_code_scanner_outlined,color: Colors.black,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment : Alignment.centerLeft,child: Image.asset(
              Assets.assetsLogoImage,  // Replace with your image path
              height: 40,
            ),),
          ),

          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  
                  shape: BoxShape.circle,
                  color: ImagineColors.red,

                ),
                child: const Icon(Icons.notifications_none,color: Colors.white,),
              ),
            )

          ],
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for better spacing
            child: BottomNavigationBar(
                items:const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                  BottomNavigationBarItem(icon: Icon(Icons.more_horiz_outlined), label: 'Settings'),
                ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped, // Handle tap events
              type: BottomNavigationBarType.fixed, // Keeps the items fixed
            )
          ),
        ),
      ),
    );

  }
}
