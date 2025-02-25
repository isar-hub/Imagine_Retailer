import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_message.dart';
import '../../repository/login_repository.dart';
import '../../routes/app_pages.dart';

class Chat_screenLogic extends GetxController {
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs; // Track if bot is typing
  final LoginRepository _loginRepository = LoginRepository();

  Future<String> getUid() async {
    final currentUser = _loginRepository.getCurrentUser();
    if (currentUser == null) {
      Get.offAllNamed(AppPages.LOGIN);
    }
    return currentUser!.uid;

  }
  final String markdownData = '''
There is 1 claim for the phone with serial number **IMG776097751**.

### Claim Details:
- **Claimed At:** February 20, 2025
- **Reason:** Phone is broken
- **Description:** The touchpad is not working
- **Status:** Pending
- **Images:**
  - ![Image 1](https://firebasestorage.googleapis.com/v0/b/imagine-bc615.appspot.com/o/customers%2Fwarranty%2F1000001849.jpg?alt=media&token=8593d1bb-df10-41a1-88c6-033af0e2aa2d)
  - ![Image 2](https://firebasestorage.googleapis.com/v0/b/imagine-bc615.appspot.com/o/customers%2Fwarranty%2F1000001848.jpg?alt=media&token=5719cda6-655b-4389-83df-8900a27ad89e)
  - ![Image 3](https://firebasestorage.googleapis.com/v0/b/imagine-bc615.appspot.com/o/customers%2Fwarranty%2F1000001847.jpg?alt=media&token=de355c03-691a-4fe4-ae91-09c67defdbce)
  - ![Image 4](https://firebasestorage.googleapis.com/v0/b/imagine-bc615.appspot.com/o/customers%2Fwarranty%2Fscaled_c83e70ff-d071-4948-a90c-1f2accb71b2a710872071388873253.jpg?alt=media&token=7f1536a0-737c-409d-bd29-ae360b7cc8f9)

If you need more information, feel free to ask!
''';
  @override
  void onInit() {
    // TODO: implement onInit
    _addWelcomeMessage();
    super.onInit();
  }

  void _addWelcomeMessage() {
    messages.add(ChatMessage(
      message: "👋 Hi there! I'm CatBot, your AI assistant from RedCat Imagine, the home of premium refurbished mobile phones. 🏆\n\nI'm here to help retailers like you with everything related to RedCat phones. Need pricing details, specs, or recommendations? Just ask! 🚀",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }
  Future<void> sendMessage(String userMessage) async {
    messages.add(ChatMessage(message: userMessage, isUser: true, timestamp: DateTime.now()));
    isLoading.value = true; // Show typing indicator

    try {
      final userId = await getUid();
      var response = await http.post(
        Uri.parse('https://primary-production-352e.up.railway.app/webhook/7595bf17-7894-418c-8b20-5b3d0575e5d8'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage,"userID": userId}),
      );

      if (response.statusCode == 200) {
        String replyText = response.body;
        messages.add(ChatMessage(message: replyText.trim(), isUser: false, timestamp: DateTime.now()));
      }  else {
        print(response.body);
        messages.add(ChatMessage(
          message: "⚠️ Oops! I'm having trouble connecting right now. Please try again in a moment.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }

    } catch (e) {
      print("Error: $e");  // Log the error for debugging purposes
      messages.add(ChatMessage(
        message: "⚠️ Something went wrong, but don't worry—our team is on it! Try again later.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }  finally {
      isLoading.value = false; // Hide typing indicator
    }
  }

}
