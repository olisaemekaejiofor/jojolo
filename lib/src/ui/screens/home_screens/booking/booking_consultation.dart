// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/book_consultation_care.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/doctors_profile.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';
import 'package:provider/provider.dart';

import '../private_chat/check_for_sub.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/text_style.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';

class BookingConsultation extends StatefulWidget {
  static const routeName = 'booking-consultation';
  const BookingConsultation({Key? key}) : super(key: key);

  @override
  State<BookingConsultation> createState() => _BookingConsultationState();
}

class _BookingConsultationState extends State<BookingConsultation> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getUser();
    controller.getDoctors();
    controller.update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(BookingController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<BookingController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Book a Consultation'),
              const SizedBox(height: 40),
              (controller.roles.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        height: 35,
                        width: double.infinity,
                        child: ListView.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              var i = controller.roles[index];
                              setState(() {
                                // controller.roles.removeAt(index);
                                controller.roles.removeAt(index);
                                controller.roles.replaceRange(0, 0, [i]);
                                if (i == 'All') {
                                  controller.doctors = controller.allDoctors;
                                } else {
                                  controller.map.forEach((key, value) {
                                    if (key == i) {
                                      controller.doctors = value;
                                    }
                                  });
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: (index == 0) ? tabColor : null,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: tabColor),
                              ),
                              child: Center(
                                child: Text(
                                  controller.roles[index],
                                  style: style(FontWeight.w500, 14,
                                      (index == 0) ? fixedBottomColor : tabColor),
                                ),
                              ),
                            ),
                          ),
                          itemCount: controller.roles.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : Container(),
              (controller.doctors.isNotEmpty)
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: List.generate(
                              controller.doctors.length,
                              (index) => doctorCard(
                                controller.doctors[index].fullName!,
                                controller.doctors[index].role!,
                                inactive: true,
                                onTap: (controller.userCaregiver.plan.isEmpty)
                                    ? () => Navigator.push(
                                          context,
                                          CustomPageRoute(
                                            child: const CheckSubscription(),
                                          ),
                                        )
                                    : (controller.userCaregiver.plan[0].isSubscribed ==
                                            false)
                                        ? () => Navigator.push(
                                              context,
                                              CustomPageRoute(
                                                child: const CheckSubscription(),
                                              ),
                                            )
                                        : (controller.userCaregiver.plan[0].value!
                                                    .virtualConsultation ==
                                                0)
                                            ? () => Navigator.push(
                                                  context,
                                                  CustomPageRoute(
                                                    child: const CheckSubscription(),
                                                  ),
                                                )
                                            : () => Navigator.push(
                                                  context,
                                                  CustomPageRoute(
                                                    child: BookConsultationCare(
                                                      doctor: controller.doctors[index],
                                                      typeofBook: 'Consultation',
                                                    ),
                                                  ),
                                                ),
                                viewProfile: () => Navigator.push(
                                  context,
                                  CustomPageRoute(
                                    child: DoctorProfile(
                                      doctor: controller.doctors[index],
                                    ),
                                  ),
                                ),
                                isChat: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                        ),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }
}

Widget doctorCard(String name, String role,
    {bool? inactive, VoidCallback? onTap, bool? isChat, VoidCallback? viewProfile}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: fixedBottomColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: viewProfile,
          child: CircleAvatar(
            backgroundColor: const Color(0xff617B7E),
            radius: 22,
            child: Center(
              child: SvgPicture.asset(
                'assets/account 1.svg',
                height: 25,
                color: fixedBottomColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: style(FontWeight.bold, 16, textColorBlack),
            ),
            Text(
              role,
              style: style(FontWeight.normal, 14, textColorBlack),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (inactive == false)
                  ? textButtonColor.withOpacity(0.5)
                  : textButtonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset(
                (isChat == false) ? 'assets/clock.svg' : 'assets/mail.svg',
                color: fixedBottomColor,
                width: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
