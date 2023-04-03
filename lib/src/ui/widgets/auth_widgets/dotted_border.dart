import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

class DottedBorderImg extends StatelessWidget {
  final String label;
  const DottedBorderImg({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorder(
      strokeWidth: 1.5,
      radius: const Radius.circular(10),
      dashPattern: const [10, 5],
      borderType: BorderType.RRect,
      color: tabColor,
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.15,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/download cloud.svg', width: 30),
              Text(
                label,
                style: style(FontWeight.w500, 15, tabColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
