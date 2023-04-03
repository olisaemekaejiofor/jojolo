import 'package:flutter/material.dart';
import '/src/controllers/home_controllers/account_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/account_widgets/account_card.dart';
import '../../../../widgets/app_widgets/auth_controls.dart';

class IdentityVerification extends StatefulWidget {
  static const routeName = 'identity-verification';
  const IdentityVerification({Key? key}) : super(key: key);

  @override
  State<IdentityVerification> createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerification> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getUser();
    super.initState();
  }

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
          return (controller.loading == true)
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(tabColor),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 60),
                    lauthControl('Account Settings'),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: verify(
                        label: 'Medical License',
                        label2: 'Upload your medical license for verification',
                        onTap: (controller.userDoctor.medicalLicenseURL != null)
                            ? () {}
                            : () => Navigator.pushNamed(context, '/add-license'),
                        verified: (controller.userDoctor.medicalLicenseURL != null)
                            ? true
                            : false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: verify(
                        label: 'Upload Valid Id Card',
                        label2: 'Upload a valid Identity card  for verification',
                        onTap: (controller.userDoctor.validIdCardUrl != null)
                            ? () {}
                            : () => Navigator.pushNamed(context, '/add-id'),
                        verified:
                            (controller.userDoctor.validIdCardUrl != null) ? true : false,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
