import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/add_child/child_details.dart';
import 'package:provider/provider.dart';

// import '/src/ui/screens/home_screens/forum/forum_screen.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

import '../../../widgets/app_widgets/buttons.dart';

class AddChild extends StatefulWidget {
  static const routeName = '/add-child';

  const AddChild({Key? key}) : super(key: key);

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getChildren();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<AccountController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const SizedBox(height: 60),
                lauthControl('Add Child'),
                const Spacer(),
                (controller.loading == false)
                    ? (controller.children.isNotEmpty)
                        ? SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                controller.children.length,
                                (index) {
                                  var d = DateTime.parse(
                                      controller.children[index].dateOfBirth);
                                  var age = Age.dateDifference(
                                      fromDate: d,
                                      toDate: DateTime.now(),
                                      includeToDate: false);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: fixedBottomColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/child-img.png',
                                          width: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.children[index].childName!,
                                              style: style(
                                                  FontWeight.w600, 16, textColorBlack),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '$age',
                                              style: style(
                                                  FontWeight.w500, 13, textColorBlack),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              SvgPicture.asset(
                                'assets/baby.svg',
                                width: size.width * 0.55,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  "Add your child so you can enjoy the benefits\nof  tracking it’s growth & development.",
                                  style: style(FontWeight.w600, 16, textColorBlack),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                    : const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(tabColor),
                        ),
                      ),
                const Spacer(),
                CustomButton(
                  label: 'Add Your Child',
                  onTap: () => Navigator.pushNamed(context, ChildDetails.routeName),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AgeDuration {
  int days;
  int months;
  int years;

  AgeDuration({this.days = 0, this.months = 0, this.years = 0});

  @override
  String toString() {
    return '$years Years, $months Months, $days Days';
  }
}

/// Age Class
class Age {
  /// _daysInMonth cost contains days per months; daysInMonth method to be used instead.
  static const List<int> _daysInMonth = [
    31, // Jan
    28, // Feb, it varies from 28 to 29
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31 // Dec
  ];

  /// isLeapYear method
  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// daysInMonth method
  static int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year)) ? 29 : _daysInMonth[month - 1];

  /// dateDifference method
  static AgeDuration dateDifference(
      {required DateTime fromDate,
      required DateTime toDate,
      bool includeToDate = false}) {
    // Check if toDate to be included in the calculation
    DateTime endDate = (includeToDate) ? toDate.add(const Duration(days: 1)) : toDate;

    int years = endDate.year - fromDate.year;
    int months = 0;
    int days = 0;

    if (fromDate.month > endDate.month) {
      years--;
      months = (DateTime.monthsPerYear + endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years,
                ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else if (endDate.month == fromDate.month) {
      if (fromDate.day > endDate.day) {
        years--;
        months = DateTime.monthsPerYear - 1;
        days = daysInMonth(fromDate.year + years,
                ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else {
      months = (endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years, (fromDate.month + months)) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    }

    return AgeDuration(days: days, months: months, years: years);
  }

  /// add method
  static DateTime add({required DateTime date, required AgeDuration duration}) {
    int years = date.year + duration.years;
    years += (date.month + duration.months) ~/ DateTime.monthsPerYear;

    int months = ((date.month + duration.months) % DateTime.monthsPerYear);

    int days = date.day + duration.days - 1;

    return DateTime(years, months, 1).add(Duration(days: days));
  }

  /// subtract methos
  static DateTime subtract({required DateTime date, required AgeDuration duration}) {
    duration.days *= -1;
    duration.months *= -1;
    duration.years *= -1;

    return add(date: date, duration: duration);
  }
}
