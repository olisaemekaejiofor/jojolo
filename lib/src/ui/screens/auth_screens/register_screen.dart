import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/counter.dart';

import 'package:provider/provider.dart';

import '../../../utils/text_style.dart';
import '../../widgets/app_widgets/auth_controls.dart';
import '../../widgets/app_widgets/buttons.dart';
import '../../widgets/app_widgets/page_item.dart';
import '../../widgets/app_widgets/tab.dart';
import '../../widgets/app_widgets/text_fields.dart';
import '/src/controllers/auth_controllers/register_controller.dart';
import '/src/ui/screens/auth_screens/login_screen.dart';
import '../../widgets/app_widgets/bottom_sheet.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterViewController controller = serviceLocator<RegisterViewController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(RegisterViewController controller) {
    return ChangeNotifierProvider<RegisterViewController>(
      create: (context) => controller,
      child: Consumer<RegisterViewController>(
        builder: (context, controller, _) {
          Size size = MediaQuery.of(context).size;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              authControl(context, LoginScreen.routeName, 'Log In'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  'Create an Account',
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
                        child: (index == 0)
                            ? caregiver(size.width * 0.4)
                            : doctor(size.width * 0.4),
                      ),
                    );
                  },
                ),
              ),
              (controller.loading == false)
                  ? CustomButton(
                      color: textButtonColor,
                      label: 'Next',
                      onTap: () => controller.register(context),
                    )
                  : const LoadingCustomButton()
            ],
          );
        },
      ),
    );
  }

  Widget caregiver(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        children: [
          TextFieldBottomSheet(
            label: 'Which Of These Roles Best Describes You?',
            list: const ['Mother', 'Father', 'Guardian'],
            controller: controller.careGiverRole,
            onChanged: (value) => controller.onChanged(value),
          ),
          const SizedBox(height: 20),
          field('Full Name', controller.fname, 'Please enter your name'),
          const SizedBox(height: 20),
          field('Email Address', controller.email, 'Please enter valid email address',
              isEmail: true),
          const SizedBox(height: 20),
          field('Phone Number', controller.phone, 'Please enter valid phone number',
              isPhone: true, type: TextInputType.number),
          const SizedBox(height: 20),
          field('Address', controller.address, ''),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: width, child: field('Country', controller.country, '')),
              SizedBox(width: width, child: field('City/State', controller.city, '')),
            ],
          ),
          const SizedBox(height: 20),
          PasswordTextField(controller: controller.password, label: 'Password'),
          const SizedBox(height: 20),
          PasswordTextField(
            controller: controller.confirm,
            label: 'Confirm Password',
            compare: controller.password.text,
            error: 'Passwords do not match',
          ),
        ],
      ),
    );
  }

  Widget doctor(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        children: [
          field('Full Name', controller.fname1, 'Enter your name'),
          const SizedBox(height: 20),
          field('Email Address', controller.email1, 'Please enter valid email address',
              isEmail: true),
          const SizedBox(height: 20),
          field('Phone Number', controller.phone, 'Please enter valid phone number',
              isPhone: true, type: TextInputType.number),
          const SizedBox(height: 20),
          field('Address', controller.address1, ''),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: width, child: field('Country', controller.country1, '')),
              SizedBox(width: width, child: field('City/State', controller.city1, '')),
            ],
          ),
          const SizedBox(height: 20),
          TextFieldBottomSheet(
            label: 'Role',
            list: const [
              'Paediatrician',
              'General Practitioner',
              'Dentist',
              'Lactationist',
              'Dermatologist',
              'Nutritionist',
              'Speech Therapist',
              'Behavioral Therapist',
              'Psychologist',
            ],
            controller: controller.profRole,
            onChanged: (value) => controller.onChanged(value),
          ),
          const SizedBox(height: 20),
          CounterWidget(counter: controller.counter),
          const SizedBox(height: 20),
          PasswordTextField(controller: controller.password1, label: 'Password'),
          const SizedBox(height: 20),
          PasswordTextField(
            controller: controller.confirm1,
            label: 'Confirm Password',
            compare: controller.password1.text,
            error: 'Passwords do not match',
          ),
        ],
      ),
    );
  }

  Widget field(String label, TextEditingController controller, String error,
      {bool? isEmail, bool? isPhone, TextInputType? type}) {
    return CustomTextField(
      controller: controller,
      label: label,
      error: error,
      isEmail: isEmail,
      isPhone: isPhone,
      type: type,
    );
  }
}
