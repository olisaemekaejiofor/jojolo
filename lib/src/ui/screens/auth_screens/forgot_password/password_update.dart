import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/login_screen.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';

import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/buttons.dart';

class PasswordUpdate extends StatelessWidget {
  static const routeName = 'password-update';
  const PasswordUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: AuthBackButton(),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Password\nUpdated',
              style: style(FontWeight.bold, 40, textColorBlack),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Your password as been updated',
              style: style(FontWeight.w500, 18, textColorBlack),
            ),
          ),
          const SizedBox(height: 100),
          CustomButton(
            show: true,
            label: 'Login',
            onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
          ),
        ],
      ),
    );
  }
}
