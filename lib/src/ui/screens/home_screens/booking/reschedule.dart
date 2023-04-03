// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:jojolo_mobile/src/data/models/user/doctor.dart';
import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/buttons.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import 'package:provider/provider.dart';

class Reschedule extends StatefulWidget {
  static const routeName = 'book-consultation-care';
  final String? caregiver;
  final UserDoctor doctor;
  final String bookingId;
  final String? typeofBook;
  const Reschedule(
      {Key? key,
      required this.doctor,
      this.typeofBook,
      this.caregiver,
      required this.bookingId})
      : super(key: key);

  @override
  State<Reschedule> createState() => _RescheduleState();
}

class _RescheduleState extends State<Reschedule> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getDetails(widget.doctor.id!);
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
            children: [
              const SizedBox(height: 60),
              lauthControl('Book a ${widget.typeofBook}'),
              const SizedBox(height: 20),
              (controller.loading == true)
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(tabColor),
                      ),
                    )
                  : Container(
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        color: fixedBottomColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: tabColor,
                            primary: tabColor,
                          ),
                        ),
                        child: Center(
                          child: CalendarDatePicker(
                            initialDate: controller.embeddedCalendar,
                            firstDate: controller.embeddedCalendar,
                            lastDate: DateTime(DateTime.now().year + 1),
                            currentDate: DateTime.now(),
                            onDateChanged: controller.onDateChanged,
                            selectableDayPredicate: (date) {
                              return controller.weekday.contains(date.weekday);
                            },
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Available Time Slots',
                          style: style(
                            FontWeight.bold,
                            18,
                            textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GroupButton(
                          buttons: controller.disabled.asMap().values.toList(),
                          controller: controller.buttonController,
                          isRadio: false,
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
                          maxSelected: 1,
                          // controller: controller,
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
                  ),
                ),
              ),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : CustomButton(
                      label: 'Reschedule Booking',
                      onTap: () => controller.rescheduleBooking(
                        context,
                        widget.doctor.id!,
                        widget.caregiver,
                        widget.bookingId,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
