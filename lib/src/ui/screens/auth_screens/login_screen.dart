// ignore_for_file: library_prefixes, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/forgot_password/forgot_password.dart';
// import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import 'package:provider/provider.dart';
import '../../widgets/app_widgets/page_item.dart';
import '/src/utils/text_style.dart';
import '/src/utils/colors.dart';
import '../../widgets/app_widgets/buttons.dart';
import '/src/controllers/auth_controllers/login_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/screens/auth_screens/register_screen.dart';
import '../../widgets/app_widgets/auth_controls.dart';
import '../../widgets/app_widgets/tab.dart';
import '../../widgets/app_widgets/text_fields.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  final String? text;

  const LoginScreen({Key? key, this.text}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewController controller = serviceLocator<LoginViewController>();

  // @override
  // void initState() {
  //   if (widget.text != null || widget.text != '') {
  //     showFlush(
  //       context,
  //       message: widget.text.toString(),
  //       image: 'assets/Active.svg',
  //       color: errorColor,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          SystemNavigator.pop();
          return true;
        } else {
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: background,
        body: _buildBody(controller),
        // bottomNavigationBar: (widget.text != null)
        //     ? SnackBar(content: Text(widget.text.toString()), backgroundColor: errorColor)
        //     : null,
      ),
    );
  }

  _buildBody(LoginViewController controller) {
    return ChangeNotifierProvider<LoginViewController>(
      create: (context) => controller,
      child: Consumer<LoginViewController>(
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              authControl(context, RegisterScreen.routeName, 'Sign Up', show: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  'Log In',
                  style: style(FontWeight.bold, 25, textColorBlack),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTab(
                  pageController: controller.controller,
                  tabController: controller.tabBarController,
                  list: controller.list,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.controller,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: PageItem(
                        index,
                        child: (index == 0) ? caregiver() : doctor(),
                      ),
                    );
                  },
                ),
              ),
              (controller.loading == false)
                  ? CustomButton(
                      label: 'Sign in',
                      onTap: () {
                        controller.login(context);
                      },
                      color: textButtonColor,
                    )
                  : const LoadingCustomButton()
            ],
          );
        },
      ),
    );
  }

  Widget caregiver() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.email,
            label: 'Email',
            error: 'Please enter valid email address',
            type: TextInputType.emailAddress,
            isEmail: true,
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            controller: controller.password,
            label: 'Password',
            type: TextInputType.text,
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              CustomPageRoute(
                child: ForgotPassword(
                  type: controller.controller.page!.toInt(),
                ),
              ),
            ),
            child: Text(
              'Forgot Password?',
              style: style(FontWeight.bold, 16, tabColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget doctor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.email,
            label: 'Email',
            error: 'Please enter valid email address',
            type: TextInputType.emailAddress,
            isEmail: true,
          ),
          const SizedBox(height: 20),
          PasswordTextField(
            controller: controller.password,
            label: 'Password',
            type: TextInputType.text,
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              CustomPageRoute(
                child: ForgotPassword(
                  type: controller.controller.page!.toInt(),
                ),
              ),
            ),
            child: Text(
              'Forgot Password?',
              style: style(FontWeight.bold, 16, tabColor),
            ),
          ),
        ],
      ),
    );
  }
}
