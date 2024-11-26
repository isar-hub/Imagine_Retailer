import 'package:flutter/material.dart';

import '../../config/constants.dart';

class SubmitButtonBody extends StatelessWidget {
  final List<Widget> children;
  final Widget stackChild;

  SubmitButtonBody({required this.children, required this.stackChild});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: children)),
        ),
        Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
                color: ImagineColors.black,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                child: stackChild)),
      ],
    );
  }
}
