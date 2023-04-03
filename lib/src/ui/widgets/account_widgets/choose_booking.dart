// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '../../../controllers/home_controllers/account_controller.dart';
import '../../../di/service_locator.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';
import '../app_widgets/buttons.dart';

class ChooseBooking extends StatefulWidget {
  final VoidCallback callBack;
  final TimeModel time;
  final GroupButtonController c;
  const ChooseBooking(
      {Key? key, required this.time, required this.c, required this.callBack})
      : super(key: key);

  @override
  State<ChooseBooking> createState() => _ChooseBookingState();
}

class _ChooseBookingState extends State<ChooseBooking> {
  final AccountController controller = serviceLocator<AccountController>();
  GroupButtonController buttonController = GroupButtonController();

  @override
  void initState() {
    buttonController = widget.c;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<AccountController>(
          builder: (context, controller, _) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: bottomNavIcon,
                    ),
                  ),
                  Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: AuthBackButton(image: 'image'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose Your Available Time Slots',
                        style: style(
                          FontWeight.bold,
                          22,
                          textColorBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GroupButton(
                        buttons: const [
                          "9:00 AM - 9:30 AM",
                          '10:00 AM - 10:30 AM',
                          '11:00 AM - 11:30 AM',
                          '12:00 PM - 12:30 PM',
                          '1:00 PM - 1:30 PM',
                          '2:00 PM - 2:30 PM',
                          '3:00 PM - 3:30 PM',
                          '4:00 PM - 4:30 PM',
                          '5:00 PM - 5:30 PM',
                          '6:00 PM - 6:30 PM'
                        ],
                        options: GroupButtonOptions(
                          buttonWidth: MediaQuery.of(context).size.width * 0.4,
                          buttonHeight: 50,
                          unselectedBorderColor: textfieldFillColor,
                          selectedShadow: const [],
                          unselectedShadow: const [],
                          selectedTextStyle: style(
                            FontWeight.w600,
                            15,
                            fixedBottomColor,
                          ),
                          selectedColor: tabColor,
                          unselectedColor: fixedBottomColor,
                          unselectedTextStyle: style(
                            FontWeight.w600,
                            15,
                            textColorBlack,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          spacing: 5,
                        ),
                        isRadio: false,
                        controller: buttonController,
                        onSelected: (val, i, selected) {
                          if (selected == true) {
                            setState(() {
                              controller.buttonController.selectIndex(i);
                            });
                          } else {
                            setState(() {
                              controller.buttonController.unselectIndex(i);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  (controller.buttonLoad == true)
                      ? const LoadingCustomButton()
                      : CustomButton(
                          label: 'Save',
                          onTap: () {
                            (widget.time.id == null)
                                ? controller.createAvailability(
                                    context, widget.time.day, buttonController)
                                : controller.updateAvailability(
                                    context,
                                    widget.time.day,
                                    buttonController,
                                    widget.time.id!,
                                    widget.time.timeId!);
                            Future.delayed(const Duration(milliseconds: 2500), () {
                              if (controller.buttonLoad == false) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                widget.callBack();
                              }
                            });
                          },
                        ),
                ],
              ),
            );
          },
        ));
  }
}
