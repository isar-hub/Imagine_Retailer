import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/screens/chat_screen/typing_loader.dart';

import '../../generated/assets.dart';
import '../../models/chat_message.dart';
import 'logic.dart';

class Chat_screenComponent extends StatelessWidget {
  Chat_screenComponent({Key? key}) : super(key: key);

  final Chat_screenLogic logic = Get.put(Chat_screenLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              child: Image.asset(Assets.assetsCatChat),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CatBot',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logic.messages.length +
                    (logic.isLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == logic.messages.length && logic.isLoading.value) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: WavyTypingIndicator(),
                    );
                  }
                  return Obx(() {
                    return _ChatBubble(message: logic.messages[index],
                      isTyping: logic.isLoading.value && index ==  logic.messages.length - 1,
                    );
                  });
                },
              );
            }),
          ),
          _ChatInput(logic: logic),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping;

  const _ChatBubble({
    required this.message,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: (){
          Clipboard.setData(ClipboardData(text: message.message));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
            bottom: 16,
            left: message.isUser ? 64 : 0,
            right: message.isUser ? 0 : 64,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.red : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: (isTyping && !message.isUser)
              ? WavyTypingIndicator() // Wavy text animation
              : AnimatedTextKit(
            key: ValueKey(message.message),
            animatedTexts: [
              TypewriterAnimatedText(
                message.message,
                textStyle: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
                speed: const Duration(milliseconds: 12),
              )
            ],
            repeatForever: false,
            totalRepeatCount: 1,
            isRepeatingAnimation: false,
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       message.message,
          //       style: TextStyle(
          //         color: message.isUser ? Colors.white : Colors.black,
          //         fontSize: 16,
          //       ),
          //     ),
          //     const SizedBox(height: 4),
          //     Row(
          //       children: [
          //         Text(
          //           _formatTime(message.timestamp),
          //           style: TextStyle(
          //             color: (message.isUser ?? false)
          //                 ? Colors.white70
          //                 : Colors.grey,
          //             fontSize: 12,
          //           ),
          //         ),
          //         const Spacer(),
          //         if (!(message.isUser))
          //           CircleAvatar(
          //             backgroundColor: Colors.red,
          //             child: Image.asset(Assets.assetsCatChat),
          //           ),
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _ChatInput extends StatelessWidget {
  final Chat_screenLogic logic;

  _ChatInput({required this.logic});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (logic.isLoading.value) {
                    return;
                  }
                  if (_controller.text
                      .trim()
                      .isNotEmpty) {
                    logic.sendMessage(_controller.text.trim());
                    _controller.clear();
                  }
                }),
          ),
        ],
      ),
    );
  }

}
