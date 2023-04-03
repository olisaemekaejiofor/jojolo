import 'package:flutter/material.dart';
import '/src/ui/widgets/app_widgets/buttons.dart';
import '/src/ui/widgets/app_widgets/text_fields.dart';
import '/src/utils/text_style.dart';
import '/src/controllers/auth_controllers/forgot_password_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = 'forgot-password';
  final int type;
  const ForgotPassword({Key? key, required this.type}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
              const SizedBox(height: 80),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Forgot\nPassword?',
                          style: style(FontWeight.bold, 40, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Provide your account’s email for which\nyou want to reset you password.',
                          style: style(FontWeight.w500, 18, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomTextField(
                          controller: controller.controller,
                          label: 'Email Address',
                          error: 'Please enter a valid email address',
                          isEmail: true,
                          type: TextInputType.emailAddress,
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
                      label: 'Next',
                      onTap: () => controller.sendCode(widget.type, context),
                    ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
