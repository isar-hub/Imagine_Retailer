import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_retailer/controller/HomeController.dart';
import 'package:intl/intl.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Homecontroller());
    log(controller.notifications.length.toString());

    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(child: Text('No notifications yet.'));
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                title: Text(notification.title,style: TextStyle(color: Colors.black),),
                subtitle: Text(notification.message,style: TextStyle(color: Colors.black)),
                trailing: Text(
                  DateFormat('dd MMM yyyy, hh:mm a')
                      .format(notification.createdAt),
                  style: TextStyle(fontSize: 12,color: Colors.black),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
