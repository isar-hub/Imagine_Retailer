import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showError(String message) {
  Get.snackbar("Error", message, backgroundColor: Colors.red);
}

void showSuccess(String message) {
  Get.snackbar("Success", message, backgroundColor: Colors.green, barBlur: 10);
}
Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255, // Full opacity
    random.nextInt(256), // Red (0-255)
    random.nextInt(256), // Green (0-255)
    random.nextInt(256), // Blue (0-255)
  );
}

Future<XFile?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
      source: source, imageQuality: 70, maxHeight: 512, maxWidth: 512);
  if (pickedFile != null) {
    return pickedFile;
  } else {
    return null;
  }
}

String now() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDate;
}

String six_months() {
  DateTime now = DateTime.now();
  DateTime sixMonthsFromNow = DateTime(
      now.year, now.month + 6, now.day, now.hour, now.minute, now.second);
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(sixMonthsFromNow);

  return formattedDate;
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'silver':
      return Colors.grey;
    case 'gold':
      return Colors.black;
    case 'platinum':
      return Colors.red;
    default:
      return Colors.blue; // Default status color
  }
}

String formatDateTime(DateTime dateTime) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  int hour = dateTime.hour;
  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format

  return '${dateTime.day} '
      '${months[dateTime.month - 1]} '
      '${dateTime.year} '
      '$hour:'
      '${dateTime.minute.toString().padLeft(2, '0')} '
      '$period';
}

List<String> getState() {
  return [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
    'Delhi',
    'Puducherry',
    'Ladakh',
    'Jammu and Kashmir',
  ];
}
