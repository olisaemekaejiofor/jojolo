import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/account/manage_sub/manage_subscription.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/pay_per_use_screen.dart';
import 'package:provider/provider.dart';

import '/src/controllers/home_controllers/chat_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';
import '../../../../utils/text_style.dart';

class CheckSubscription extends StatefulWidget {
  const CheckSubscription({Key? key}) : super(key: key);

  @override
  State<CheckSubscription> createState() => _CheckSubscriptionState();
}

class _CheckSubscriptionState extends State<CheckSubscription> {
  final ChatController controller = serviceLocator<ChatController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(ChatController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ChatController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Make Payment'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'You are currently not subscribed to any of our plans, select from any of the paymrent options below and continue enjoying our services.',
                  style: style(FontWeight.w600, 18, textColorBlack),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSubscriptionCard(
                      title: 'Subscription',
                      price:
                          'Choose from our available subscription\nplans (basic, standard or premium).',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ManageSubscription.routeName);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSubscriptionCard(
                      title: 'Pay-per-use',
                      price:
                          'Pay a one-time fee for this service using\npaystack.',
                      onPressed: () {
                        Navigator.pushNamed(context, PayPerUseScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSubscriptionCard(
                      title: 'Jojolo Points',
                      price: 'Make use of your Jojolo Points. ',
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _buildSubscriptionCard({
    required String title,
    required String price,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: fixedBottomColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: style(FontWeight.w600, 14, tabColor),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: style(FontWeight.w600, 15, textColorBlack),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
