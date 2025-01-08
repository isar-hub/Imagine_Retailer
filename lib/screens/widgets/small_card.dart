import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imagine_retailer/config/constants.dart';

class SmallCard extends StatelessWidget {

  final IconData logo;
  final String title;
  final String num;
  const SmallCard({
    Key? key,
    required this.logo,
    required this.title,
    required this.num,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF02aab0), // Start color
            Color(0xFF00cdac), // End color
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(logo,size: 40,),
          const SizedBox(height: 8), // Add some space between logo and title
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4), // Space between title and num
          Text(
            num,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
