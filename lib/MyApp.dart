import 'package:flutter/material.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/screens/home_activity.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Imagine",
      theme: ImagineTheme.themeData(context),
      home: HomeActivity(),
    );
  }
}
