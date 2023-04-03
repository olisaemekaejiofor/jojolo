// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';
import 'package:provider/provider.dart';

class BookingRequest extends StatefulWidget {
  static const routeName = 'booking-request';
  const BookingRequest({Key? key}) : super(key: key);

  @override
  State<BookingRequest> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<BookingRequest> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getBookingRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  Widget rowText(String image, String text) {
    return Row(
      children: [
        SvgPicture.asset(image, color: textButtonColor, width: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: style(FontWeight.w600, 13, textColorBlack),
        ),
      ],
    );
  }

  _buildBody(BookingController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<BookingController>(
        builder: (context, controller, _) {
          Size size = MediaQuery.of(context).size;
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('My Booking Requests'),
              (controller.loading == true)
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(tabColor),
                        ),
                      ),
                    )
                  : (controller.rideRequest.isNotEmpty)
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                controller.rideRequest.length,
                                (index) {
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 20),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: fixedBottomColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        rowHeader(
                                          controller
                                              .rideRequest[index].caregiverId!.fullName!,
                                          controller.rideRequest[index].caregiverId!
                                              .rolesDescription!,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          controller.rideRequest[index].typeOfService!,
                                          style:
                                              style(FontWeight.bold, 15, textColorBlack),
                                        ),
                                        const SizedBox(height: 20),
                                        rowText(
                                          'assets/calendar.svg',
                                          DateFormat.yMMMEd()
                                              .format((controller.rideRequest[index]
                                                          .typeOfService !=
                                                      null)
                                                  ? DateTime.parse(controller
                                                      .rideRequest[index].startTime!)
                                                  : controller
                                                      .rideRequest[index].createdAt!)
                                              .toString(),
                                        ),
                                        const SizedBox(height: 10),
                                        rowText(
                                          'assets/clock.svg',
                                          DateFormat.jm().format((controller
                                                          .rideRequest[index]
                                                          .typeOfService !=
                                                      null)
                                                  ? DateTime.parse(controller.rideRequest[index].startTime!)
                                                      .add(const Duration(hours: 1))
                                                  : controller
                                                      .rideRequest[index].createdAt!) +
                                              ' - ' +
                                              DateFormat.jm().format((controller
                                                          .rideRequest[index]
                                                          .typeOfService !=
                                                      null)
                                                  ? DateTime.parse(controller.rideRequest[index].startTime!)
                                                      .add(const Duration(minutes: 90))
                                                  : controller
                                                      .rideRequest[index].createdAt!
                                                      .add(const Duration(minutes: 30))),
                                        ),
                                        const SizedBox(height: 15),
                                        rowButton(
                                          size.width * 0.35,
                                          accept: () => controller.acceptRequest(
                                            controller
                                                .rideRequest[index].availabilityId!.id!,
                                            controller.rideRequest[index].id!,
                                            controller
                                                .rideRequest[index].caregiverId!.id!,
                                            context,
                                            index,
                                          ),
                                          decline: () => controller.decline(
                                            controller
                                                .rideRequest[index].availabilityId!.id!,
                                            controller.rideRequest[index].id!,
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
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              const Spacer(),
                              SvgPicture.asset(
                                'assets/booking_request.svg',
                                width: 300,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No Requests',
                                style: style(FontWeight.bold, 18, textColorBlack),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'You currently have no booking requests',
                                style: style(FontWeight.w500, 16, textColorBlack),
                              ),
                              const SizedBox(height: 40),
                              const Spacer(),
                            ],
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }
}

Widget rowButton(double width,
    {bool? chat, VoidCallback? accept, VoidCallback? decline}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(
      2,
      (index) => GestureDetector(
        onTap: (index == 0) ? decline : accept,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (index == 0) ? backButtonBackground : textButtonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              (chat == true)
                  ? (index == 0)
                      ? 'End Chat'
                      : 'Continue Chat'
                  : (index == 0)
                      ? 'Decline'
                      : 'Accept',
              style:
                  style(FontWeight.w600, 14, (index == 0) ? tabColor : fixedBottomColor),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget rowHeader(String name, String role) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: const Color(0xff617B7E),
        radius: 22,
        child: Center(
            child: SvgPicture.asset(
          'assets/account 1.svg',
          height: 20,
          color: fixedBottomColor,
        )),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: style(FontWeight.bold, 15, textColorBlack),
          ),
          Text(
            role,
            style: style(FontWeight.w500, 13, textColorBlack),
          )
        ],
      ),
    ],
  );
}
