import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/text_style.dart';

class NotificationSettings extends StatefulWidget {
  static const routeName = 'notification-settings';
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<AccountController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const SizedBox(height: 60),
                lauthControl('Notifications Settings'),
                const SizedBox(height: 30),
                switchRow('Push Notifications', controller.notifications.pushNotification,
                    onToggle: (val) {
                  setState(() {
                    controller.notifications.pushNotification =
                        !controller.notifications.pushNotification;
                  });
                  controller.setNotifications(context);
                }),
                const SizedBox(height: 30),
                switchRow(
                    'Email Notifications', controller.notifications.emailNotification,
                    onToggle: (val) {
                  setState(() {
                    controller.notifications.emailNotification =
                        !controller.notifications.emailNotification;
                  });
                  controller.setNotifications(context);
                }),
                const SizedBox(height: 30),
                switchRow('SMS Notifications', controller.notifications.smsNotification,
                    onToggle: (val) {
                  setState(() {
                    controller.notifications.smsNotification =
                        !controller.notifications.smsNotification;
                  });
                  controller.setNotifications(context);
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget switchRow(String label, bool value, {required void Function(bool) onToggle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style(FontWeight.w600, 16, textColorBlack),
          ),
          FlutterSwitch(
            value: value,
            onToggle: onToggle,
            width: 45,
            height: 27,
            padding: 1.5,
            inactiveColor: textfieldFillColor,
            activeColor: tabColor,
          ),
        ],
      ),
    );
  }
}
