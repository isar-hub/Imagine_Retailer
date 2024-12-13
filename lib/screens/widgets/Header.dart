import 'package:flutter/material.dart';

Widget buildHeader(String label, {Color color = Colors.red})=> Column(
  children: [
    const SizedBox(height: 10),
     Text(
      label,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:color ),
    ),
     Divider(color: color),
  ],
);