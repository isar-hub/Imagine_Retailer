


import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../scanner/mlkit_scanner/barcode_scanner.dart';
import '../screens/home_activity.dart';
import '../screens/notification_view.dart';
import '../screens/settings.dart';
import '../screens/user_view.dart';
import '../screens/warranty_view.dart';


part 'app_routes.dart';


class AppPages {
  AppPages._();

  static const HOME = Routes.HOME;
  static var SCANNER = Routes.SCANNER;
  static const USER = Routes.USER;
  static const SETTINGS = Routes.SETTINGS;
  static const WARRANTY = Routes.WARRANTY;
  static const NOTIFICATION = Routes.NOTIFICATION;


  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeActivity(),
    ),
    GetPage(
      name: _Paths.SCANNER,
      page: () => const BarcodeScannerView(),

    ),
    GetPage(
      transition: Transition.zoom,
      name: _Paths.USER,
      page: () =>  UserView(),

    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsPage(),

    ),
    GetPage(
      name: _Paths.WARRANTY,
      page: () => const WarrantyView(),

    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),

    ),
  ];
}