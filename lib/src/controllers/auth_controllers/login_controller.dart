import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';

import '../../data/api_data/api_data.dart';
import '../../di/service_locator.dart';

class LoginViewController extends ChangeNotifier {
  final Login _loginClient = serviceLocator<Login>();
  final PageController controller = PageController(initialPage: 0);
  final CustomTabBarController tabBarController = CustomTabBarController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  List<String> list = ['Caregivers', 'Health Professionals'];
  bool loading = false;

  void login(BuildContext context) async {
    loading = true;
    notifyListeners();
    if (email.text.isEmpty || password.text.isEmpty) {
      loading = false;
      showFlush(
        context,
        message: 'You can’t continue because there’s an\nempty field in the form.',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    } else {
      if (controller.page == 0) {
        String value = await _loginClient.login(email.text, password.text, 'caregiver');
        if (value == 'Login') {
          loading = false;
          Navigator.pushNamed(context, 'forum');
          notifyListeners();
        } else {
          loading = false;
          showFlush(
            context,
            message: value,
            image: 'assets/Active.svg',
            color: errorColor,
          );
          notifyListeners();
        }
      } else if (controller.page == 1) {
        String value = await _loginClient.login(email.text, password.text, 'd');
        if (value == 'Login') {
          loading = false;
          Navigator.pushNamed(context, 'forum');
          notifyListeners();
        } else {
          loading = false;
          showFlush(
            context,
            message: value,
            image: 'assets/Active.svg',
            color: errorColor,
          );
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }
}
