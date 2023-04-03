// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/booking.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/forum/forum_screen.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/private_chat.dart';

class NotificationController extends ChangeNotifier {
  final PostFeed post = serviceLocator<PostFeed>();
  bool butttonLoad = true;
  List<Notices> notifications = [];

  void listenToSocket() async {
    notifications = await post.getNotificationHistory();
    butttonLoad = false;
    notifyListeners();
  }

  void selectNotice(BuildContext ctx, int index) {
    post.setNotification(notifications[index].id!);
    if (notifications[index].title == 'Chat Activity') {
      Navigator.pushNamed(ctx, PrivateChat.routeName);
    } else if (notifications[index].title == 'Booking Activity') {
      Navigator.pushNamed(ctx, Booking.routeName);
    } else {
      Navigator.pushNamed(ctx, Forum.routeName);
    }
  }
}

class Notifications {
  String notification;
  String title;
  Notifications({required this.notification, required this.title});
}
