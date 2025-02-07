import 'dart:ui';
import 'package:flutter/material.dart';

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(
    this.context,
  );

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final paint = Paint();
    paint.imageFilter = ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0);

    paint.color = Colors.black.withOpacity(0.6);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(0, 0, width, height, Radius.circular(0))),
        Path()
          ..addRect(Rect.fromLTRB(
              10, (height / 2) - 170, width - 10, (height / 2) + 50))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return false;
  }
}


