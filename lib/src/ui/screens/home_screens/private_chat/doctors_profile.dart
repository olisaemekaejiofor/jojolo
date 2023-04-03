import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/chat_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/booking_consultation.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/booking_models/list_doctor.dart';

class DoctorProfile extends StatefulWidget {
  final ListDoctor doctor;
  const DoctorProfile({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final ChatController controller = serviceLocator<ChatController>();
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
          Size size = MediaQuery.of(context).size;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const AuthBackButton(),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xff617B7E),
                          radius: 40,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/account 1.svg',
                              height: 40,
                              color: fixedBottomColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctor.fullName!,
                              style: style(FontWeight.bold, 18, textColorBlack),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.doctor.role!,
                              style: style(FontWeight.normal, 16, textColorBlack),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: tabColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              Text(
                                (index == 0)
                                    ? '${widget.doctor.consultationHistory.length}'
                                    : (index == 1)
                                        ? '${widget.doctor.yearsOfExperience} yrs'
                                        : '5.0',
                                style: style(FontWeight.bold, 25, fixedBottomColor),
                              ),
                              const Spacer(),
                              Text(
                                (index == 0)
                                    ? 'Consultation'
                                    : (index == 1)
                                        ? 'Experience'
                                        : 'Ratings',
                                style: style(FontWeight.w600, 14, fixedBottomColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        2,
                        (index) => GestureDetector(
                          onTap: (index == 0)
                              ? () {
                                  Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      child: const BookingConsultation(),
                                    ),
                                  );
                                }
                              : () {},
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: size.width * 0.42,
                            height: 120,
                            decoration: BoxDecoration(
                              color: backButtonBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: tabColor,
                                  child: SvgPicture.asset(
                                    (index == 0) ? 'assets/on.svg' : 'assets/mail.svg',
                                    width: 20,
                                    color: fixedBottomColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  (index == 0)
                                      ? 'Book a Virtual\nConsultation'
                                      : 'Chat With Doctor',
                                  style: style(FontWeight.w600, 16, tabColor),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Doctor's Bio",
                      style: style(FontWeight.bold, 18, textColorBlack),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.doctor.bio.toString(),
                      style: style(FontWeight.w500, 16, textColorBlack),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: controller.load,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: fixedBottomColor.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                    ),
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
