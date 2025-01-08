import 'package:flutter/material.dart';
import 'package:imagine_retailer/config/constants.dart';

class Labelcard extends StatelessWidget {
  final String title;
  final Widget content;

  const Labelcard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ImagineColors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width:double.infinity,
            color: ImagineColors.white,
            child: Text(
              title,
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          content
        ],
      ),
    );
  }
}

