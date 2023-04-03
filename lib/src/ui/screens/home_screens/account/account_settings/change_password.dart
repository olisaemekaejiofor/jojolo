import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:provider/provider.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/ui/widgets/app_widgets/buttons.dart';
import '/src/ui/widgets/app_widgets/text_fields.dart';
import '/src/utils/colors.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = 'change-password';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AccountController controller = serviceLocator<AccountController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(AccountController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Change Password'),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        PasswordTextField(
                          controller: controller.old,
                          label: 'Old Password',
                          error: '',
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          controller: controller.newp,
                          label: 'New Password',
                          error: '',
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          controller: controller.confirm,
                          label: 'Confirm Password',
                          error: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : CustomButton(
                      label: 'Change password',
                      onTap: () => controller.changePassword(context),
                    )
            ],
          );
        },
      ),
    );
  }
}
