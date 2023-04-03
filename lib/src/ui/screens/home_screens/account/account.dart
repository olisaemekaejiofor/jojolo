import 'package:flutter/material.dart';
import 'package:jojolo_mobile/app.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/login_screen.dart';
import 'package:provider/provider.dart';
import '/src/ui/widgets/account_widgets/account_card.dart';
import '/src/utils/bottom_navigation.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

class Account extends StatefulWidget {
  static const routeName = 'account';
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
      bottomNavigationBar: BottomNavBar(index: 5),
      body: _buildBody(controller),
    );
  }

  _buildBody(AccountController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Account',
                  style: style(FontWeight.bold, 25, textColorBlack),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: (controller.userType == 'caregiver')
                        ? Column(
                            children: [
                              accountCard(
                                label: 'Account Settings',
                                image: 'assets/user.svg',
                                onTap: () =>
                                    Navigator.pushNamed(context, 'account-settings'),
                              ),
                              accountCard(
                                label: 'Notification Settings',
                                image: 'assets/notification on.svg',
                                color: tabColor,
                                onTap: () =>
                                    Navigator.pushNamed(context, 'notification-settings'),
                              ),
                              accountCard(
                                label: 'Manage Subscriptions',
                                image: 'assets/credit card.svg',
                                onTap: () => Navigator.pushNamed(context, 'manage-subs'),
                              ),
                              accountCard(
                                label: 'Consultation History',
                                image: 'assets/clipboard.svg',
                                onTap: () =>
                                    Navigator.pushNamed(context, 'consult-history'),
                              ),
                              // accountCard(
                              //   label: 'My Jojolo Points',
                              //   image: 'assets/award.svg',
                              //   onTap: () =>
                              //       Navigator.pushNamed(context, 'jojolo-points'),
                              // ),
                              // accountCard(
                              //   label: 'Donate',
                              //   image: 'assets/gift.svg',
                              //   onTap: () => Navigator.pushNamed(context, 'donate'),
                              // ),
                              accountCard(
                                  label: 'Logout',
                                  image: 'assets/log out.svg',
                                  logout: true,
                                  onTap: () {
                                    controller.logout();
                                    Navigator.pushNamed(
                                      context,
                                      LoginScreen.routeName,
                                      arguments: ScreenArguments(text: ''),
                                    );
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              accountCard(
                                label: 'Account Settings',
                                image: 'assets/user.svg',
                                onTap: () =>
                                    Navigator.pushNamed(context, 'account-settings'),
                              ),
                              accountCard(
                                label: 'Notification Settings',
                                image: 'assets/notification on.svg',
                                color: tabColor,
                                onTap: () =>
                                    Navigator.pushNamed(context, 'notification-settings'),
                              ),
                              accountCard(
                                label: 'Earnings',
                                image: 'assets/credit card.svg',
                                onTap: () => Navigator.pushNamed(context, 'earnings'),
                              ),
                              accountCard(
                                label: 'Manage Bookings',
                                image: 'assets/clock.svg',
                                color: tabColor,
                                onTap: () =>
                                    Navigator.pushNamed(context, 'manage-bookings'),
                              ),
                              // accountCard(
                              //   label: 'My Jojolo Points',
                              //   image: 'assets/award.svg',
                              //   onTap: () =>
                              //       Navigator.pushNamed(context, 'jojolo-points'),
                              // ),
                              // accountCard(
                              //   label: 'Donate',
                              //   image: 'assets/gift.svg',
                              //   onTap: () => Navigator.pushNamed(context, 'donate'),
                              // ),
                              accountCard(
                                label: 'Logout',
                                image: 'assets/log out.svg',
                                logout: true,
                                onTap: () {
                                  controller.logout();
                                  Navigator.pushNamed(context, LoginScreen.routeName);
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
