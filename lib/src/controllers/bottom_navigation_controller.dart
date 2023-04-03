import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/data/storage_data/storage_data.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';

class BottomNavController extends ChangeNotifier {
  final Storage store = serviceLocator<Storage>();
  int value = 1;
  String? userType;

  void getType() async {
    var type = await store.getUserType();
    userType = type;
    notifyListeners();
  }

  void select(int val, BuildContext ctx) {
    value = val;
    if (value == 1) {
      Navigator.pushNamed(ctx, 'forum');
    } else if (value == 3) {
      Navigator.pushNamed(ctx, 'booking');
    } else if (value == 2) {
      Navigator.pushNamed(ctx, 'private-chat');
    } else if (value == 5) {
      Navigator.pushNamed(ctx, 'account');
    }
    notifyListeners();
  }
}
