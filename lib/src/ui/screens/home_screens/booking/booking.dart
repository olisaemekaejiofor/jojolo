import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/check_for_sub.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import 'package:provider/provider.dart';

import '/src/di/service_locator.dart';
import '/src/utils/bottom_navigation.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';
import '../../../../controllers/home_controllers/booking_controller.dart';
import '../../../widgets/book_widgets/book_cards.dart';

class Booking extends StatefulWidget {
  static const routeName = 'booking';
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getType();
    controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: BottomNavBar(index: 3),
      body: _buildBody(controller),
    );
  }

  _buildBody(BookingController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<BookingController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            child: (controller.type == 'caregiver')
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Text('Booking',
                            style: style(FontWeight.bold, 30, textColorBlack)),
                        const SizedBox(height: 20),
                        (controller.loading == true)
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(tabColor),
                                ),
                              )
                            : Column(
                                children: [
                                  bookingCards(
                                    'My Booking Schedule',
                                    'assets/calendar.svg',
                                    onTap: () =>
                                        Navigator.pushNamed(context, 'booking-schedule'),
                                    color: textButtonColor,
                                    second: backgroundBooking,
                                  ),
                                  bookingCards(
                                    'Book a Consultation',
                                    'assets/on.svg',
                                    onTap: () => Navigator.pushNamed(
                                        context, 'booking-consultation'),
                                    onInfo: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        builder: (context) {
                                          return info(
                                            'assets/on.svg',
                                            'Virtual Consultation',
                                            'Jojolo offers you access to the expert advice and services of verified doctors, paediatricians and health specialists via video consultation. Jojolo’s virtual consultations are for children who you may be worried are ill or unwell.',
                                            context,
                                          );
                                        }),
                                    color: tabColor,
                                    second: backgroundBooking1,
                                    info: true,
                                  ),
                                  bookingCards(
                                    'Book a Vaccination Service',
                                    'assets/vaccination.svg',
                                    onTap: (controller.userCaregiver.plan.isEmpty)
                                        ? () => Navigator.push(
                                              context,
                                              CustomPageRoute(
                                                child: const CheckSubscription(),
                                              ),
                                            )
                                        : (controller
                                                    .userCaregiver.plan[0].isSubscribed ==
                                                false)
                                            ? () => Navigator.push(
                                                  context,
                                                  CustomPageRoute(
                                                    child: const CheckSubscription(),
                                                  ),
                                                )
                                            : (controller.userCaregiver.plan[0].value!
                                                        .vaccinationService ==
                                                    0)
                                                ? () => Navigator.push(
                                                      context,
                                                      CustomPageRoute(
                                                        child: const CheckSubscription(),
                                                      ),
                                                    )
                                                : () {
                                                    Navigator.pushNamed(
                                                        context, 'vaccination-service');
                                                  },
                                    onInfo: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        builder: (context) {
                                          return info(
                                            'assets/vaccination.svg',
                                            'Vaccination Service',
                                            'Jojolo’s Vaccination Service helps you schedule essential vaccines for your little one to be delivered at a location of your choice by verified health workers.',
                                            context,
                                          );
                                        }),
                                    color: tabColor,
                                    second: backgroundBooking1,
                                    info: true,
                                  ),
                                  bookingCards(
                                    'Book a Wellness Checkup',
                                    'assets/lotus.svg',
                                    onTap: () =>
                                        Navigator.pushNamed(context, 'wellness-checkup'),
                                    onInfo: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        builder: (context) {
                                          return info(
                                            'assets/lotus.svg',
                                            'Wellness Checkup',
                                            'Jojolo’s Wellness Checkup provides a comprehensive assessment of your child’s health status and offers you recommendations about your child’s health needs. It is for children who are stable but you need them checked by a doctor.',
                                            context,
                                          );
                                        }),
                                    color: tabColor,
                                    second: backgroundBooking1,
                                    info: true,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Text('Booking',
                            style: style(FontWeight.bold, 30, textColorBlack)),
                        const SizedBox(height: 20),
                        bookingCards(
                          'My Booking Schedule',
                          'assets/calendar.svg',
                          onTap: () => Navigator.pushNamed(context, 'booking-schedule'),
                          color: textButtonColor,
                          second: backgroundBooking,
                        ),
                        bookingCards(
                          'My Booking Request',
                          'assets/chat.svg',
                          onTap: () => Navigator.pushNamed(context, 'booking-request'),
                          color: tabColor,
                          second: backgroundBooking1,
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
