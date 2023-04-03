import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:provider/provider.dart';

import '../../../../../../utils/colors.dart';
import '../../../../../widgets/account_widgets/account_card.dart';

class ManageBookings extends StatefulWidget {
  static const routeName = 'manage-bookings';
  const ManageBookings({Key? key}) : super(key: key);

  @override
  State<ManageBookings> createState() => _ManageBookingsState();
}

class _ManageBookingsState extends State<ManageBookings> {
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
              lauthControl('Manage Bookings'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    accountCard(
                      label: 'Set Available Dates & Time',
                      image: 'assets/calendar.svg',
                      color: tabColor,
                      onTap: () => Navigator.pushNamed(context, 'book-consultation'),
                    ),
                    accountCard(
                      label: 'Consultation History',
                      image: 'assets/clipboard.svg',
                      color: tabColor,
                      onTap: () => Navigator.pushNamed(context, 'consult-history'),
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
}
