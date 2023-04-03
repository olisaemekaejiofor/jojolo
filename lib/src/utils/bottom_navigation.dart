// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/src/controllers/bottom_navigation_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

class BottomNavBar extends StatefulWidget {
  int index = 1;
  BottomNavBar({Key? key, required this.index}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  BottomNavController controller = serviceLocator<BottomNavController>();

  @override
  void initState() {
    controller.getType();
    controller.value = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(controller);
  }

  _buildBody(BottomNavController controller) {
    return ChangeNotifierProvider<BottomNavController>(
      create: (context) => controller,
      child: Consumer<BottomNavController>(
        builder: (context, controller, _) {
          Size size = MediaQuery.of(context).size;
          return Container(
            width: double.infinity,
            height: size.height * 0.1,
            decoration: const BoxDecoration(
              color: fixedBottomColor,
              boxShadow: [
                BoxShadow(
                  color: Color(0xffE8E8E8),
                  offset: Offset(0, -2),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: (controller.userType != 'caregiver')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      selectWidget(
                        1,
                        label: 'Forum',
                        icon: 'conversation 1',
                        onTap: () => controller.select(1, context),
                      ),
                      selectWidget(
                        2,
                        label: 'Private Chat',
                        icon: 'mail',
                        onTap: () => controller.select(2, context),
                      ),
                      selectWidget(
                        3,
                        label: 'Booking',
                        icon: 'clock',
                        onTap: () => controller.select(3, context),
                      ),
                      selectWidget(
                        5,
                        label: 'Account',
                        icon: 'account 1',
                        onTap: () => controller.select(5, context),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      selectWidget(
                        1,
                        label: 'Forum',
                        icon: 'conversation 1',
                        onTap: () => controller.select(1, context),
                      ),
                      selectWidget(
                        2,
                        label: 'Private Chat',
                        icon: 'mail',
                        onTap: () => controller.select(2, context),
                      ),
                      selectWidget(
                        3,
                        label: 'Booking',
                        icon: 'clock',
                        onTap: () => controller.select(3, context),
                      ),
                      selectWidget(
                        5,
                        label: 'Account',
                        icon: 'account 1',
                        onTap: () => controller.select(5, context),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget selectWidget(int index,
      {required String label, required String icon, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            'assets/$icon.svg',
            color: (controller.value == index) ? tabColor : bottomNavIcon,
            width: 25,
          ),
          Text(
            label,
            style: style(FontWeight.w600, 15,
                (controller.value == index) ? tabColor : bottomNavIcon),
          ),
          (controller.value == index)
              ? SvgPicture.asset(
                  'assets/Polygon 1 (1).svg',
                  height: 10,
                  color: tabColor,
                )
              : const SizedBox(height: 10),
        ],
      ),
    );
  }
}
