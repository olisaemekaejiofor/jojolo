import 'package:flutter/material.dart';

import 'package:flutter_custom_tab_bar/library.dart';
import 'package:file_picker/file_picker.dart';

import '../../../app.dart';
import '/src/ui/screens/auth_screens/login_screen.dart';
import '/src/data/api_data/api_data.dart';
import '/src/di/service_locator.dart';
import '/src/utils/notifiers.dart';
import '../../ui/widgets/app_widgets/app_flush.dart';
import '../../utils/colors.dart';

class RegisterViewController extends ChangeNotifier {
  final Register _register = serviceLocator<Register>();
  final PageController controller = PageController(initialPage: 0);
  final CustomTabBarController tabBarController = CustomTabBarController();

  final TextEditingController careGiverRole = TextEditingController();
  final TextEditingController profRole = TextEditingController();
  final TextEditingController fname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController confirm = TextEditingController();

  final TextEditingController fname1 = TextEditingController();
  final TextEditingController email1 = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  final TextEditingController phone1 = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController country1 = TextEditingController();
  final TextEditingController city1 = TextEditingController();
  final TextEditingController confirm1 = TextEditingController();

  CounterNotifier counter = CounterNotifier();
  RadioNotifier radio = RadioNotifier();

  List<String> list = ['Caregivers', 'Health Professionals'];
  bool loading = false;
  String? id;
  String? license;
  int val = -1;

  void onChanged(String value) {
    debugPrint(value);
  }

  void register(BuildContext ctx) async {
    loading = true;
    notifyListeners();
    if (controller.page == 0) {
      if (careGiverRole.text == '' ||
          fname.text == '' ||
          email.text == '' ||
          phone.text == '' ||
          address.text == '' ||
          country.text == '' ||
          city.text == '' ||
          password.text == '' ||
          confirm.text == '') {
        loading = false;
        showFlush(
          ctx,
          message: 'You can’t continue because there’s an\nempty field in the form.',
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      } else {
        String data = await _register.registerCaregiver(
          careGiverRole.text,
          fname.text,
          email.text,
          phone.text,
          address.text,
          city.text,
          country.text,
          password.text,
          confirm.text,
        );

        if (data != 'done') {
          loading = false;
          showFlush(
            ctx,
            message: data,
            image: 'assets/Active.svg',
            color: errorColor,
          );
          notifyListeners();
        } else {
          showFlush(
            ctx,
            message: 'Caregiver Account Successfully Created',
            image: 'assets/Active2.svg',
            color: greenColor,
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(
              ctx,
              LoginScreen.routeName,
              arguments: ScreenArguments(
                  text:
                      'Please check your email for a verification link\nYou need to verify your account before you can login to your account'),
            );
          });
        }
      }
    } else {
      if (profRole.text == '' ||
          fname1.text == '' ||
          email1.text == '' ||
          phone.text == '' ||
          address1.text == '' ||
          country1.text == '' ||
          city1.text == '' ||
          password1.text == '' ||
          confirm1.text == '') {
        loading = false;
        showFlush(
          ctx,
          message: 'You can’t continue because there’s an\nempty field in the form.',
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      } else {
        String data = await _register.registerDoctor(
          profRole.text,
          fname1.text,
          email1.text,
          phone.text,
          address1.text,
          city1.text,
          country1.text,
          counter.value.toString(),
          password1.text.trim(),
          confirm1.text.trim(),
        );
        if (data != 'done') {
          loading = false;
          showFlush(
            ctx,
            message: data,
            image: 'assets/Active.svg',
            color: errorColor,
          );
          notifyListeners();
        } else {
          showFlush(
            ctx,
            message: 'Doctor Account Successfully Created',
            image: 'assets/Active2.svg',
            color: greenColor,
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(
              ctx,
              LoginScreen.routeName,
              arguments: ScreenArguments(
                  text:
                      'Please check your email for a verification link\nYou need to verify your account before you can login to your account'),
            );
          });
        }
      }
      notifyListeners();
    }
  }

  Future imgLicense() async {
    var doc = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"],
        allowCompression: false);

    license = doc!.paths.first;
    notifyListeners();
  }

  Future imgID() async {
    var doc = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"],
        allowCompression: false);

    id = doc!.paths.first;
    notifyListeners();
  }

  void updateLicense(BuildContext ctx) async {
    loading = true;
    notifyListeners();
    if (license != null) {
      String data = await _register.updateMedLicensce(license!);
      if (data != 'done') {
        loading = false;
        showFlush(
          ctx,
          message: data,
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      } else {
        loading = false;
        showFlush(
          ctx,
          message: 'License added successfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(ctx);
        });
        notifyListeners();
      }
    } else {
      loading = false;
      showFlush(
        ctx,
        message: 'Please attach your medical license',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void updateId(BuildContext ctx) async {
    loading = true;
    notifyListeners();
    if (id != null) {
      String data = await _register.updateValidId(id!);
      if (data != 'done') {
        loading = false;
        showFlush(
          ctx,
          message: data,
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      } else {
        loading = false;
        showFlush(
          ctx,
          message: 'ID added successfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(ctx);
        });
        notifyListeners();
      }
    } else {
      loading = false;
      showFlush(
        ctx,
        message: 'Please attach your valid id',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void cancel() {
    license = null;
    id = null;
    notifyListeners();
  }
}
