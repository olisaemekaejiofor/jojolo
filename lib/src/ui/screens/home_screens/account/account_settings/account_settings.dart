import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/account_widgets/account_card.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  static const routeName = 'account-settings';
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getType();
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
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Account Settings'),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: accountCard(
                  label: 'Profile Settings',
                  image: 'assets/user.svg',
                  onTap: () => Navigator.pushNamed(context, 'profile-settings'),
                ),
              ),
              (controller.userType == 'caregiver')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: accountCard(
                        label: 'Add Child',
                        image: 'assets/add-child.svg',
                        onTap: () => Navigator.pushNamed(context, '/add-child'),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: accountCard(
                  label: 'Change Password',
                  image: 'assets/key.svg',
                  onTap: () => Navigator.pushNamed(context, 'change-password'),
                ),
              ),
              (controller.userType == 'doctor')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: accountCard(
                        label: 'Identity Verification',
                        image: 'assets/user check.svg',
                        onTap: () =>
                            Navigator.pushNamed(context, 'identity-verification'),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
