// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/check_for_sub.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/doctor_chat_page.dart';
import 'package:jojolo_mobile/src/utils/bottom_navigation.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import 'package:provider/provider.dart';

import '../../../../utils/text_style.dart';
import '../booking/booking_consultation.dart';
import '../booking/booking_request.dart';
import '/src/utils/colors.dart';
import '../../../../controllers/home_controllers/chat_controller.dart';
import 'chat_page.dart';
import 'doctors_profile.dart';

class PrivateChat extends StatefulWidget {
  static const routeName = 'private-chat';
  const PrivateChat({Key? key}) : super(key: key);

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  late Timer _timer;
  // final Storage store = serviceLocator<Storage>();

  @override
  void initState() {
    final controller = Provider.of<ChatController>(context, listen: false);
    controller.getType();
    controller.getDoctors();
    controller.getChatRequests();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      controller.getChatRequests();
      controller.reload();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: BottomNavBar(index: 2),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Consumer<ChatController>(
      builder: (context, controller, _) {
        Size size = MediaQuery.of(context).size;
        return (controller.type == 'caregiver')
            ? Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Private Chat',
                          style: style(FontWeight.bold, 30, textColorBlack),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      const SizedBox(height: 30),
                      (controller.loading == true)
                          ? const Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                                ),
                              ),
                            )
                          : (controller.doctors.isNotEmpty)
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        controller.doctors.length,
                                        (index) {
                                          var doctorCard2 = doctorCard(
                                            controller.doctors[index].fullName!,
                                            controller.doctors[index].role!,
                                            inactive:
                                                controller.doctors[index].isVerified,
                                            onTap: (controller
                                                    .userCaregiver!.plan.isNotEmpty)
                                                ? () => Navigator.push(
                                                      context,
                                                      CustomPageRoute(
                                                        child: ChatPage(
                                                            doctor:
                                                                controller.doctors[index],
                                                            chatRequest: (controller
                                                                    .chatrequest
                                                                    .where((e) =>
                                                                        e.doctorId?.id ==
                                                                        controller
                                                                            .doctors[
                                                                                index]
                                                                            .id)
                                                                    .toList()
                                                                    .isNotEmpty)
                                                                ? controller.chatrequest
                                                                    .firstWhere((e) =>
                                                                        e.doctorId?.id ==
                                                                        controller
                                                                            .doctors[
                                                                                index]
                                                                            .id)
                                                                : null),
                                                      ),
                                                    )
                                                : () => Navigator.push(
                                                    context,
                                                    CustomPageRoute(
                                                        child:
                                                            const CheckSubscription())),
                                            viewProfile: () => Navigator.push(
                                                context,
                                                CustomPageRoute(
                                                    child: DoctorProfile(
                                                  doctor: controller.doctors[index],
                                                ))),
                                            isChat: true,
                                          );
                                          return doctorCard2;
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                    ],
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
                  ),
                ],
              )
            : (controller.loading == false)
                ? (controller.chatrequest.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'Private Chat',
                              style: style(FontWeight.bold, 30, textColorBlack),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  controller.chatrequest.length,
                                  (index) {
                                    return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: fixedBottomColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          rowHeader(
                                              controller.chatrequest[index].caregiverId!
                                                  .fullName!,
                                              controller.chatrequest[index].caregiverId!
                                                  .rolesDescription!),
                                          const SizedBox(height: 15),
                                          rowButton(
                                            size.width * 0.35,
                                            chat: (controller.chatrequest[index].status ==
                                                    'ACCEPTED')
                                                ? true
                                                : false,
                                            accept:
                                                (controller.chatrequest[index].status ==
                                                        'ACCEPTED')
                                                    ? () => Navigator.push(
                                                          context,
                                                          CustomPageRoute(
                                                            child: DoctorChatPage(
                                                              doctor: controller
                                                                  .chatrequest[index],
                                                            ),
                                                          ),
                                                        )
                                                    : () => controller.acceptRequest(
                                                        controller.chatrequest[index].id!,
                                                        controller.chatrequest[index],
                                                        context),
                                            decline: (controller
                                                        .chatrequest[index].status ==
                                                    'ACCEPTED')
                                                ? () => controller.endChat(
                                                      controller.chatrequest[index],
                                                      controller
                                                          .doctor.bookingsId.first.id!,
                                                      index,
                                                      context,
                                                    )
                                                : () => controller.declineRequest(
                                                      controller.chatrequest[index].id!,
                                                      context,
                                                      index,
                                                    ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            Text(
                              'Private Chat',
                              style: style(FontWeight.bold, 30, textColorBlack),
                            ),
                            const Spacer(),
                            Center(
                              child: SvgPicture.asset(
                                'assets/private-chat.svg',
                                width: 300,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: Text(
                                'No Chats',
                                style: style(FontWeight.bold, 18, textColorBlack),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                'You currently have no live private chat with any patient',
                                style: style(FontWeight.w500, 16, textColorBlack),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Spacer(),
                          ],
                        ),
                      )
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                    ),
                  );
      },
    );
  }
}
