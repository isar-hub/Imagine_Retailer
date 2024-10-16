import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imagine_retailer/scanner/scanner_controller.dart';

import 'MyApp.dart';

void main() {
  Get.lazyPut(() => ScannerController());
  runApp(const MyApp());
}

