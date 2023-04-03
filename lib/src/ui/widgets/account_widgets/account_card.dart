import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

Widget accountCard({
  required String label,
  required String image,
  bool? logout,
  void Function()? onTap,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(label,
              style: style(
                  FontWeight.w600, 18, (logout == true) ? errorColor : textColorBlack)),
        ],
      ),
    ),
  );
}

Widget verify({
  required String label,
  required String label2,
  bool? verified,
  void Function()? onTap,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: style(FontWeight.bold, 17, textColorBlack)),
              const SizedBox(height: 5),
              Text(label2, style: style(FontWeight.w500, 14, textColorBlack)),
            ],
          ),
          const Spacer(),
          (verified == true)
              ? Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, color: greenColor),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: fixedBottomColor,
                      size: 20,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}
