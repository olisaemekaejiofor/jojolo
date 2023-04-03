import 'package:flutter/material.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/ui/screens/home_screens/booking/book_consultation_care.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';
import '/src/utils/page_route.dart';
import '/src/utils/text_style.dart';
import 'package:provider/provider.dart';

import '../../../../di/service_locator.dart';
import '../private_chat/check_for_sub.dart';
import '../private_chat/doctors_profile.dart';
import 'booking_consultation.dart';

class WellnessCheckup extends StatefulWidget {
  static const routeName = 'wellness-checkup';
  const WellnessCheckup({Key? key}) : super(key: key);

  @override
  State<WellnessCheckup> createState() => _WellnessCheckupState();
}

class _WellnessCheckupState extends State<WellnessCheckup> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getUser();
    controller.getDoctors();
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
              lauthControl('Book a Wellness Checkup'),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Wellness checkups are important to ensure good health. If your health is important to you, wellness exams should be too.',
                  style: style(FontWeight.normal, 18, textColorBlack),
                ),
              ),
              const SizedBox(height: 40),
              (controller.doctors.isNotEmpty)
                  ? Expanded(
                      child: SingleChildScrollView(
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
                                                  .wellnessCheckup ==
                                              0)
                                          ? () => Navigator.push(
                                                context,
                                                CustomPageRoute(
                                                  child: const CheckSubscription(),
                                                ),
                                              )
                                          : () {
                                              Navigator.push(
                                                context,
                                                CustomPageRoute(
                                                  child: BookConsultationCare(
                                                    doctor: controller.doctors[index],
                                                    typeofBook: 'Wellness Checkup',
                                                  ),
                                                ),
                                              );
                                            },
                              isChat: false,
                              viewProfile: () => Navigator.push(
                                context,
                                CustomPageRoute(
                                  child: DoctorProfile(
                                    doctor: controller.doctors[index],
                                  ),
                                ),
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
