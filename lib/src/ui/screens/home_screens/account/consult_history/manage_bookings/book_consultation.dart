// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:group_button/group_button.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../../../../../di/service_locator.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/text_style.dart';
import '../../../../../widgets/account_widgets/choose_booking.dart';

class BookConsultation extends StatefulWidget {
  static const routeName = 'book-consultation';
  const BookConsultation({Key? key}) : super(key: key);

  @override
  State<BookConsultation> createState() => _BookConsultationState();
}

class _BookConsultationState extends State<BookConsultation> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getUser();
    super.initState();
  }

  getUser() {
    controller.getUser();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              lauthControl('Book Consultation'),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Choose Your Available Days',
                          style: style(FontWeight.bold, 18, textColorBlack),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: List.generate(controller.days.length, (index) {
                            return chooseDay(
                              controller.days[index].day,
                              value: controller.days[index].available,
                              onToggle: (val) {
                                if (val == true) {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    builder: (context) {
                                      return ChooseBooking(
                                        callBack: getUser,
                                        time: controller.days[index],
                                        c: GroupButtonController(),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    controller.days[index].available =
                                        !controller.days[index].available;
                                  });
                                }
                              },
                              onTap: () {
                                controller.chooseDay(controller.days[index].weekDay);
                                if (controller
                                    .buttonController.selectedIndexes.isNotEmpty) {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    builder: (context) {
                                      return ChooseBooking(
                                        callBack: getUser,
                                        time: controller.days[index],
                                        c: controller.buttonController,
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : CustomButton(
                      label: 'Save',
                      onTap: () => controller.deleteAvailability(context),
                    )
            ],
          );
        },
      ),
    );
  }

  Widget chooseDay(String text,
      {VoidCallback? onTap, required bool value, required void Function(bool) onToggle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: fixedBottomColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          FlutterSwitch(
            value: value,
            onToggle: onToggle,
            width: 45,
            height: 27,
            padding: 1.5,
            inactiveColor: textfieldFillColor,
            activeColor: tabColor,
          ),
          const Spacer(),
          Text(text, style: style(FontWeight.w600, 18, textColorBlack)),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: tabColor),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: fixedBottomColor,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
