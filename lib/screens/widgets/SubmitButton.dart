import 'package:flutter/material.dart';

import '../../config/constants.dart';

class SubmitButton extends StatelessWidget {
  final Function() onPressed;
  SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: ImagineColors.white,
          textStyle: TextStyle(color: ImagineColors.black),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          'Submit',
          style: TextStyle(
              color: ImagineColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ));
  }
}
