// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/booking_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/add_child/add_child.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/account/manage_sub/manage_subscription.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/booking_consultation.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/booking_vaccination.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/post_consultation_form.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/booking/reschedule.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';
import 'package:provider/provider.dart';

import '../../../../utils/text_style.dart';

class BookingSchedule extends StatefulWidget {
  static const routeName = 'booking-schedule';
  const BookingSchedule({Key? key}) : super(key: key);

  @override
  State<BookingSchedule> createState() => _BookingScheduleState();
}

class _BookingScheduleState extends State<BookingSchedule> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getBookingSchedule();
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
          Size size = MediaQuery.of(context).size;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              lauthControl('My Booking Schedule'),
              (controller.loading == true)
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(tabColor),
                        ),
                      ),
                    )
                  : (controller.rideRequest.isEmpty)
                      ? Expanded(
                          child: Column(
                            children: [
                              const Spacer(),
                              SvgPicture.asset('assets/schedule.svg', width: 350),
                              const SizedBox(height: 10),
                              Text(
                                'No Scheduled Events',
                                style: style(FontWeight.bold, 20, textColorBlack),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'You currently have no events in your booking\nschedule',
                                style: style(FontWeight.w500, 16, textColorBlack),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              (controller.type == 'caregiver')
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        2,
                                        (index) => GestureDetector(
                                          onTap: (index == 0)
                                              ? (controller.userCaregiver.plan.isEmpty)
                                                  ? () => Navigator.pushNamed(context,
                                                      ManageSubscription.routeName)
                                                  : () => Navigator.pushNamed(context,
                                                      BookingConsultation.routeName)
                                              : (controller.userCaregiver
                                                      .childInformationId.isEmpty)
                                                  ? () {
                                                      Navigator.pushNamed(
                                                          context, AddChild.routeName);
                                                    }
                                                  : () {
                                                      Navigator.pushNamed(context,
                                                          VaccinationService.routeName);
                                                    },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: size.width * 0.42,
                                            decoration: BoxDecoration(
                                              color: backButtonBackground,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: tabColor,
                                                  child: SvgPicture.asset(
                                                    (index == 0)
                                                        ? 'assets/on.svg'
                                                        : 'assets/vaccination.svg',
                                                    width: 20,
                                                    color: fixedBottomColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  (index == 0)
                                                      ? 'Book a\nConsultation'
                                                      : 'Book a Vaccination\nService',
                                                  style: style(
                                                      FontWeight.w600, 16, tabColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                Text(
                                  'Next Event',
                                  style: style(FontWeight.bold, 18, textColorBlack),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: tabColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      rowHeader(
                                        (controller.type == 'caregiver')
                                            ? (controller.rideRequest[0].typeOfService ==
                                                    null)
                                                ? "Vaccination Booking"
                                                : controller
                                                    .rideRequest[0].doctorId!.fullName!
                                                    .toString()
                                            : controller
                                                .rideRequest[0].caregiverId!.fullName!,
                                        (controller.type == 'caregiver')
                                            ? (controller.rideRequest[0].typeOfService ==
                                                    null)
                                                ? "Vaccination Booking"
                                                : controller
                                                    .rideRequest[0].doctorId!.role!
                                            : controller.rideRequest[0].caregiverId!
                                                .rolesDescription!,
                                        onTap: () => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          builder: (context) {
                                            return BookOptions(
                                              initial: (controller.type == 'caregiver')
                                                  ? false
                                                  : true,
                                              complete: () => Navigator.push(
                                                context,
                                                CustomPageRoute(
                                                  child: PostConsultationForm(
                                                    id: controller
                                                        .rideRequest[0].caregiverId!.id!,
                                                    aid: controller.rideRequest[0]
                                                        .availabilityId!.id!,
                                                    bid: controller.rideRequest[0].id!,
                                                  ),
                                                ),
                                              ),
                                              reschedule: (controller
                                                          .rideRequest[0].typeOfService ==
                                                      null)
                                                  ? () {}
                                                  : () {
                                                      Navigator.push(
                                                        context,
                                                        CustomPageRoute(
                                                          child: Reschedule(
                                                            doctor: controller.ds[0],
                                                            bookingId: controller
                                                                .rideRequest[0].id!,
                                                            typeofBook: 'Reschedule',
                                                            caregiver: (controller.type ==
                                                                    'caregiver')
                                                                ? controller
                                                                    .rideRequest[0]
                                                                    .caregiverId!
                                                                    .id!
                                                                : controller
                                                                    .rideRequest[0]
                                                                    .caregiverId!
                                                                    .id!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              cancel: (controller
                                                          .rideRequest[0].typeOfService ==
                                                      null)
                                                  ? () {}
                                                  : (controller.type == 'caregiver')
                                                      ? () {
                                                          Navigator.pop(context);
                                                          controller.cancelRequest(
                                                              controller
                                                                  .rideRequest[0].id!,
                                                              context,
                                                              22234);
                                                        }
                                                      : () {
                                                          Navigator.pop(context);
                                                          controller.declineRequest(
                                                              controller.rideRequest[0]
                                                                  .availabilityId!.id!,
                                                              controller
                                                                  .rideRequest[0].id!,
                                                              controller.rideRequest[0]
                                                                  .caregiverId!.id!,
                                                              context,
                                                              22234);
                                                        },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        controller.rideRequest[0].typeOfService ??
                                            "Vaccination Service",
                                        style:
                                            style(FontWeight.w600, 16, fixedBottomColor),
                                      ),
                                      const SizedBox(height: 20),
                                      rowText(
                                        'assets/calendar.svg',
                                        DateFormat.yMMMEd()
                                            .format((controller
                                                        .rideRequest[0].typeOfService !=
                                                    null)
                                                ? DateTime.parse(
                                                    controller.rideRequest[0].startTime!)
                                                : controller.rideRequest[0].createdAt!)
                                            .toString(),
                                      ),
                                      const SizedBox(height: 20),
                                      rowText(
                                        'assets/clock.svg',
                                        DateFormat.jm().format((controller
                                                        .rideRequest[0].typeOfService !=
                                                    null)
                                                ? DateTime.parse(controller
                                                        .rideRequest[0].startTime!)
                                                    .add(const Duration(hours: 1))
                                                : controller.rideRequest[0].createdAt!) +
                                            ' - ' +
                                            DateFormat.jm().format(
                                              (controller.rideRequest[0].typeOfService !=
                                                      null)
                                                  ? DateTime.parse(controller
                                                          .rideRequest[0].startTime!)
                                                      .add(const Duration(minutes: 90))
                                                  : controller.rideRequest[0].createdAt!
                                                      .add(
                                                      const Duration(minutes: 30),
                                                    ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Upcoming Events',
                                  style: style(FontWeight.w700, 17, textColorBlack),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        controller.ride.length,
                                        (index) => Container(
                                          padding: const EdgeInsets.all(20),
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: fixedBottomColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              rowHeader(
                                                (controller.type == 'caregiver')
                                                    ? (controller.ride[0].typeOfService ==
                                                            null)
                                                        ? "Vaccination Booking"
                                                        : controller.ride[index].doctorId!
                                                            .fullName!
                                                            .toString()
                                                    : controller.ride[index].caregiverId!
                                                        .fullName!,
                                                (controller.type == 'caregiver')
                                                    ? (controller.ride[0].typeOfService ==
                                                            null)
                                                        ? ""
                                                        : controller
                                                            .ride[index].doctorId!.role!
                                                    : controller.ride[index].caregiverId!
                                                        .rolesDescription!,
                                                first: true,
                                                onTap: () => showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),
                                                    ),
                                                  ),
                                                  builder: (context) {
                                                    return BookOptions(
                                                      reschedule: (controller.ride[0]
                                                                  .typeOfService ==
                                                              null)
                                                          ? () {}
                                                          : () {
                                                              Navigator.push(
                                                                context,
                                                                CustomPageRoute(
                                                                  child: Reschedule(
                                                                    doctor:
                                                                        controller.ds[0],
                                                                    bookingId: controller
                                                                        .ride[index].id!,
                                                                    typeofBook:
                                                                        'Reschedule',
                                                                    caregiver: controller
                                                                        .ride[index]
                                                                        .caregiverId!
                                                                        .id!,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                      cancel: (controller.ride[0]
                                                                  .typeOfService ==
                                                              null)
                                                          ? () {}
                                                          : (controller.type ==
                                                                  'caregiver')
                                                              ? () {
                                                                  Navigator.pop(context);
                                                                  controller
                                                                      .cancelRequest(
                                                                          controller
                                                                              .ride[index]
                                                                              .id!,
                                                                          context,
                                                                          index);
                                                                }
                                                              : () {
                                                                  Navigator.pop(context);
                                                                  controller.declineRequest(
                                                                      controller
                                                                          .ride[index]
                                                                          .availabilityId!
                                                                          .id!,
                                                                      controller
                                                                          .rideRequest[0]
                                                                          .id!,
                                                                      controller
                                                                          .rideRequest[0]
                                                                          .caregiverId!
                                                                          .id!,
                                                                      context,
                                                                      index);
                                                                },
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                controller.ride[index].typeOfService ??
                                                    "Vaccination Service",
                                                style: style(
                                                    FontWeight.w600, 16, textColorBlack),
                                              ),
                                              const SizedBox(height: 10),
                                              rowText(
                                                'assets/calendar.svg',
                                                DateFormat.yMMMEd()
                                                    .format((controller.ride[index]
                                                                .typeOfService !=
                                                            null)
                                                        ? DateTime.parse(controller
                                                            .ride[index].startTime!)
                                                        : controller
                                                            .ride[index].createdAt!)
                                                    .toString(),
                                                first: true,
                                              ),
                                              const SizedBox(height: 20),
                                              rowText(
                                                'assets/clock.svg',
                                                DateFormat.jm().format((controller
                                                                .ride[index]
                                                                .typeOfService !=
                                                            null)
                                                        ? DateTime.parse(controller.ride[index].startTime!)
                                                            .add(const Duration(hours: 1))
                                                        : controller
                                                            .ride[index].createdAt!) +
                                                    ' - ' +
                                                    DateFormat.jm().format((controller
                                                                .ride[index]
                                                                .typeOfService !=
                                                            null)
                                                        ? DateTime.parse(controller.ride[index].startTime!).add(
                                                            const Duration(minutes: 90))
                                                        : controller
                                                            .ride[index].createdAt!
                                                            .add(const Duration(minutes: 30))),
                                                first: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }

  Widget rowHeader(String name, String role, {bool? first, VoidCallback? onTap}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: (first == true) ? const Color(0xff617B7E) : textfieldFillColor,
          radius: first == true ? 20 : 30,
          child: Center(
              child: SvgPicture.asset(
            'assets/account 1.svg',
            height: first == true ? 15 : 25,
            color: first == true ? fixedBottomColor : textColorBlack,
          )),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: style(FontWeight.bold, first == true ? 16 : 18,
                  first == true ? textColorBlack : fixedBottomColor),
            ),
            Text(
              role,
              style: style(FontWeight.w500, first == true ? 15 : 13,
                  first == true ? textColorBlack : fixedBottomColor),
            )
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert,
              color: first == true ? textColorBlack : Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget rowText(String image, String text, {bool? first}) {
    return Row(
      children: [
        SvgPicture.asset(image,
            color: first == true ? textColorBlack : fixedBottomColor, width: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: style(
              FontWeight.w600, 13, first == true ? textColorBlack : fixedBottomColor),
        ),
      ],
    );
  }
}

class BookOptions extends StatelessWidget {
  final bool? initial;
  final VoidCallback? complete;
  final VoidCallback? reschedule;
  final VoidCallback? cancel;
  const BookOptions({Key? key, this.initial, this.complete, this.reschedule, this.cancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.28,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: textColorBlack,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: size.width * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (initial == true)
                      ? GestureDetector(
                          onTap: complete,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Text(
                              'Complete',
                              style: style(FontWeight.w600, 18, textColorBlack),
                            ),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: reschedule,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Reschedule',
                        style: style(FontWeight.w600, 18, textColorBlack),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: cancel,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Cancel',
                        style: style(FontWeight.w600, 18, textColorBlack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
