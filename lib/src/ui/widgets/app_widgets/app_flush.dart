import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

void showFlush(BuildContext context,
    {required String message,
    required String image,
    required Color color,
    Duration? duration}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: true,
    duration: duration ?? const Duration(seconds: 3),
    message: message,
    icon: SvgPicture.asset(image),
    messageColor: fixedBottomColor,
    backgroundColor: color,
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
    borderRadius: BorderRadius.circular(10),
    messageText: Text(
      message,
      style: style(FontWeight.w600, 16, fixedBottomColor),
    ),
  ).show(context);
}
