import 'package:flutter/material.dart';
import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/buttons.dart';
import '../../../widgets/app_widgets/text_fields.dart';
import '/src/controllers/auth_controllers/forgot_password_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';

import 'package:provider/provider.dart';

class VerifyCode extends StatefulWidget {
  static const routeName = 'verify-code';
  final int type;
  const VerifyCode({Key? key, required this.type}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Verify Code',
                          style: style(FontWeight.bold, 40, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'We sent you a verification code to verify your email.',
                          style: style(FontWeight.w500, 18, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomTextField(
                          controller: controller.controller,
                          label: 'Input Code',
                          error: 'Please enter a valid email address',
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
                      label: 'Verify Code',
                      onTap: () => controller.verifyCode(widget.type, context),
                    ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
