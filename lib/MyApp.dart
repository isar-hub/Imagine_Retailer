
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/routes/app_pages.dart';

import 'config/constants.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Imagine",
      theme: ImagineTheme.themeData(context),
      initialRoute: AppPages.LOGIN ,
      getPages: AppPages.routes,
    );
  }
}
