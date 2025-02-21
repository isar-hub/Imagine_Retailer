import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class WavyTypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText("typing..."),
        ],
        repeatForever: true,
        isRepeatingAnimation: true,
      ),
    );
  }
}
