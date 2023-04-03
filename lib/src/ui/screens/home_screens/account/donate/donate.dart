import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

class Donate extends StatelessWidget {
  static const routeName = 'donate';
  const Donate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          const SizedBox(height: 60),
          lauthControl('Donate'),
          const Spacer(),
          SvgPicture.asset('assets/donate.svg', width: 200),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Help make the world a better place by joining us in\nour goal of bringing adequate healthcare to those\nwho do not have access to healthcare services.',
              style: style(FontWeight.normal, 14, textColorBlack),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          CustomButton(
            label: 'Donate',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
