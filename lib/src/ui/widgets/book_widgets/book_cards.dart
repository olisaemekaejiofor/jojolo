import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';
import '../app_widgets/buttons.dart';

Widget info(
  String image,
  String title,
  String desc,
  BuildContext ctx,
) {
  Size size = MediaQuery.of(ctx).size;
  return Container(
    width: double.infinity,
    height: size.height * 0.5,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      color: fixedBottomColor,
    ),
    child: Column(
      children: [
        Container(
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: textColorBlack,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: AuthBackButton(image: 'image'),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: tabColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              image,
              width: 25,
              color: fixedBottomColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'What is $title?',
          style: style(FontWeight.w700, 20, textColorBlack),
        ),
        const SizedBox(height: 10),
        Text(
          desc,
          style: style(FontWeight.w500, 17, textColorBlack),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget bookingCards(
  String label,
  String icon, {
  Color? color,
  Color? second,
  bool? info,
  VoidCallback? onInfo,
  required VoidCallback onTap,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: second,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  color: fixedBottomColor,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(label, style: style(FontWeight.w600, 16, fixedBottomColor)),
            const Spacer(),
            (info == true)
                ? GestureDetector(
                    onTap: onInfo,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: fixedBottomColor,
                        size: 20,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    ),
  );
}
