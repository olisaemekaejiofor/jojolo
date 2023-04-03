import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import 'package:provider/provider.dart';

class JojoloPoints extends StatefulWidget {
  static const routeName = 'jojolo-points';
  const JojoloPoints({Key? key}) : super(key: key);

  @override
  State<JojoloPoints> createState() => _JojoloPointsState();
}

class _JojoloPointsState extends State<JojoloPoints> {
  final AccountController controller = serviceLocator<AccountController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(AccountController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              lauthControl('My Jojolo Points'),
              const SizedBox(height: 30),
              const PointsWallet(),
              const SizedBox(height: 30),
              const PointClass(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Points History',
                  style: style(FontWeight.bold, 16, textColorBlack),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      PointHistoryCard(),
                      PointHistoryCard(),
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
}

class PointsWallet extends StatelessWidget {
  const PointsWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: tabColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Jojolo Points',
            style: style(FontWeight.bold, 14, backButtonBackground),
          ),
          const SizedBox(height: 10),
          Text(
            '10,500',
            style: style(FontWeight.bold, 40, Colors.white),
          ),
        ],
      ),
    );
  }
}

class PointClass extends StatelessWidget {
  const PointClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/Platinum Badge.png', height: 50),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: style(FontWeight.bold, 15, textColorBlack),
              children: [
                const TextSpan(text: "You're a Jojolo "),
                TextSpan(
                  text: '"Super Mom" 🎉',
                  style: style(FontWeight.bold, 15, textButtonColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PointHistoryCard extends StatelessWidget {
  const PointHistoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: style(FontWeight.w600, 15, textColorBlack),
              children: [
                const TextSpan(text: "Congratulations you just became a Jojolo\n"),
                TextSpan(
                  text: '"Super Mom" 🎉',
                  style: style(FontWeight.bold, 15, textButtonColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "300 points",
            style: style(FontWeight.bold, 15, textColorBlack),
          )
        ],
      ),
    );
  }
}
