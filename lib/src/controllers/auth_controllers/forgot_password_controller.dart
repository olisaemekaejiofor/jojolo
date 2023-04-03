// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/forgot_password/reset_password.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import '../../ui/screens/auth_screens/forgot_password/verify_code.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool loading = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  final ForgotPass _client = serviceLocator<ForgotPass>();

  void sendCode(int type, BuildContext ctx) async {
    loading = true;
    notifyListeners();
    bool check = await _client.send(controller.text, type);

    if (check == true) {
      loading = false;
      Navigator.push(ctx, CustomPageRoute(child: VerifyCode(type: type)));
      notifyListeners();
    } else {
      loading = false;
      showFlush(
        ctx,
        message: (type == 0) ? 'Caregiver is not available' : 'Doctor is not available',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void verifyCode(int type, BuildContext ctx) async {
    loading = true;
    notifyListeners();
    String check = await _client.verifyCode(controller.text, type);

    if (check != 'failed') {
      loading = false;
      Navigator.push(
          ctx, CustomPageRoute(child: ResetPassword(email: check, type: type)));
      notifyListeners();
    } else {
      loading = false;
      showFlush(
        ctx,
        message: 'Invalid Code',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void updatePassword(String email, int type, BuildContext ctx) async {
    loading = true;
    notifyListeners();
    bool check = await _client.updatePassword(email, controller.text, confirm.text, type);

    if (check == true) {
      loading = false;
      Navigator.pushNamed(ctx, 'password-update');
      notifyListeners();
    } else {
      loading = false;
      showFlush(
        ctx,
        message: 'Could not update password',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
    notifyListeners();
  }
}
