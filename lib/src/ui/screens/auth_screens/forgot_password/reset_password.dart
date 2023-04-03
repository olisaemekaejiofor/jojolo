import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/auth_controllers/forgot_password_controller.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/buttons.dart';
import '../../../widgets/app_widgets/text_fields.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = 'reset-password';
  final String email;
  final int type;
  const ResetPassword({Key? key, required this.email, required this.type})
      : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ForgotPasswordController controller = serviceLocator<ForgotPasswordController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(ForgotPasswordController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ForgotPasswordController>(
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: AuthBackButton(),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'New\nCredentials',
                  style: style(FontWeight.bold, 40, textColorBlack),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Your identity has been verified set\nyour new password',
                          style: style(FontWeight.w500, 18, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                        child: PasswordTextField(
                          controller: controller.controller,
                          label: 'New Password',
                          error: '',
                          type: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                        child: PasswordTextField(
                          controller: controller.confirm,
                          label: 'Confirm Password',
                          error: '',
                          type: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (controller.loading == true)
                  ? const LoadingCustomButton(show: true)
                  : CustomButton(
                      show: true,
                      label: 'Update',
                      onTap: () =>
                          controller.updatePassword(widget.email, widget.type, context),
                    ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
