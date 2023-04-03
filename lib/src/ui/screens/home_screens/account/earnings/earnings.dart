import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Earnings extends StatefulWidget {
  static const routeName = 'earnings';
  const Earnings({Key? key}) : super(key: key);

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  late List<EarningData> _chartData;
  final AccountController controller = serviceLocator<AccountController>();
  @override
  void initState() {
    controller.getWalletBalance();
    _chartData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: ChangeNotifierProvider<AccountController>(
        create: (context) => controller,
        child: Consumer<AccountController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const SizedBox(height: 60),
                lauthControl('Earnings'),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      color: fixedBottomColor, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Balance',
                        style: style(FontWeight.w600, 14, textColorGrey),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₦ ${controller.wallet}',
                            style: style(FontWeight.bold, 35, textColorBlack),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: textColorBlack,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Withdraw Funds',
                                            style: style(
                                                FontWeight.bold, 18, textColorBlack),
                                          ),
                                          const Spacer(),
                                          const AuthBackButton(image: 'q')
                                        ],
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Wallet Balance',
                                          style:
                                              style(FontWeight.w600, 14, textColorGrey),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '₦ ${controller.wallet}',
                                          style:
                                              style(FontWeight.bold, 20, textButtonColor),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomButton(label: 'Withdraw', onTap: () {}),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: tabColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Withdraw',
                                style: style(FontWeight.w600, 14, fixedBottomColor),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(25),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Earnings (N)',
                            style: style(FontWeight.bold, 16, textColorBlack),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SfCartesianChart(
                          legend: Legend(
                            alignment: ChartAlignment.near,
                            orientation: LegendItemOrientation.vertical,
                            isVisible: true,
                            isResponsive: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            position: LegendPosition.top,
                            textStyle: style(
                              FontWeight.w500,
                              11,
                              textColorBlack,
                            ),
                          ),
                          plotAreaBorderWidth: 0,
                          series: <ChartSeries>[
                            StackedColumnSeries<EarningData, String>(
                              width: 0.25,
                              dataSource: _chartData,
                              xValueMapper: (EarningData exp, _) => exp.earningCategory,
                              yValueMapper: (EarningData exp, _) => exp.virtual,
                              name: 'Virtual Consultation',
                              color: tabColor,
                            ),
                            StackedColumnSeries<EarningData, String>(
                              width: 0.25,
                              dataSource: _chartData,
                              xValueMapper: (EarningData exp, _) => exp.earningCategory,
                              yValueMapper: (EarningData exp, _) => exp.wellness,
                              name: 'Wellness Checkup',
                              color: const Color(0xff9AB82E),
                            ),
                            StackedColumnSeries<EarningData, String>(
                              width: 0.25,
                              dataSource: _chartData,
                              xValueMapper: (EarningData exp, _) => exp.earningCategory,
                              yValueMapper: (EarningData exp, _) => exp.physical,
                              name: 'Physical Consultation',
                              color: textButtonColor,
                            ),
                            StackedColumnSeries<EarningData, String>(
                              width: 0.25,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              dataSource: _chartData,
                              xValueMapper: (EarningData exp, _) => exp.earningCategory,
                              yValueMapper: (EarningData exp, _) => exp.chat,
                              name: 'Private Chat',
                              color: const Color(0xff6F19B0),
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 0),
                            labelFormat: '{value}K',
                            majorTickLines: const MajorTickLines(size: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Payment History',
                      style: style(FontWeight.bold, 18, textColorBlack),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        controller.paymentHistory.length,
                        (i) => Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.paymentHistory[i].text!,
                                    style: style(
                                      FontWeight.w600,
                                      18,
                                      textColorBlack,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd-MM-yyyy")
                                        .format(controller.paymentHistory[i].createdAt!)
                                        .toString(),
                                    style: style(
                                      FontWeight.w500,
                                      15,
                                      textColorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                (controller.paymentHistory[i].status == 'EARN')
                                    ? '+' + controller.paymentHistory[i].amount.toString()
                                    : '-' +
                                        controller.paymentHistory[i].amount.toString(),
                                style: style(
                                  FontWeight.w600,
                                  16,
                                  greenColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  List<EarningData> getData() {
    final List<EarningData> chart = [
      EarningData(
        earningCategory: 'Jan',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Feb',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Mar',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Apr',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'May',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Jun',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Jul',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Aug',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Sep',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Oct',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Nov',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
      EarningData(
        earningCategory: 'Dec',
        virtual: 0,
        physical: 0,
        wellness: 0,
        chat: 0,
      ),
    ];
    return chart;
  }
}

class EarningData {
  final String earningCategory;
  final int? virtual;
  final int? physical;
  final int? wellness;
  final int? chat;

  EarningData({
    required this.earningCategory,
    required this.virtual,
    required this.physical,
    required this.wellness,
    required this.chat,
  });
}
