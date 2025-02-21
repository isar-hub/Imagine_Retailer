import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imagine_retailer/screens/chat_screen/view.dart';

import '../../generated/assets.dart';
import '../../models/chat_message.dart';

class DraggableButton extends StatefulWidget {
  const DraggableButton({super.key});

  @override
  _DraggableButtonScreenState createState() => _DraggableButtonScreenState();
}

class _DraggableButtonScreenState extends State<DraggableButton> {
  final messages = [
    ChatMessage(
      message: "Hi! Can you help me with something?",
      isUser: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      message: "I'm always happy to help! Happy to help you out! What's on your mind?",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    // Add more messages as needed
  ];

  Offset position = const Offset(300, 600); // Initial position of the button
  bool isDragging = false;
  double screenWidth = 0.0;
  final double bottomBarHeight = 70.0; // Approx height of bottom nav bar

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 300),
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              (position.dx + details.delta.dx).clamp(0, screenWidth - 56), // Prevent overflow
              (position.dy + details.delta.dy),
            );
          });
        },
        onPanEnd: (_) {
          setState(() {
            isDragging = false;
            double middle = screenWidth / 2;
            position = Offset(
              position.dx < middle ? 0 : screenWidth - 56, // Snap to closest edge
              position.dy,
            );
          });
        },
        child: FloatingActionButton(
          onPressed: () {
            Get.to(()=> Chat_screenComponent());
          },
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Image.asset(Assets.assetsCatChat),
        ),
      ),
    );
  }
}
