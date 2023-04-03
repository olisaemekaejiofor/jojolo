import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

Widget customRadioButton(String text, int index, int value,
    {void Function()? onPressed}) {
  return Row(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE8E8E8)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: (index == value)
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: textButtonColor,
                  ),
                  padding: const EdgeInsets.all(2.0),
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(
                      child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  )))
              : Container(),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        text,
        style: style(FontWeight.w600, 14, textColorBlack),
      ),
    ],
  );
}
