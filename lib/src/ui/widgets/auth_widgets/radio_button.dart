import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

import '../../../utils/notifiers.dart';

class CustomRadio extends StatefulWidget {
  final RadioNotifier radio;

  const CustomRadio({
    Key? key,
    required this.radio,
  }) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
      valueListenable: widget.radio,
      builder: (context, value, child) {
        return SizedBox(
          height: size.height * 0.1,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.43,
                    child: customRadioButton('National ID card', 1,
                        onPressed: () => widget.radio.select(1)),
                  ),
                  SizedBox(
                    width: size.width * 0.43,
                    child: customRadioButton('Drivers License', 2,
                        onPressed: () => widget.radio.select(2)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.43,
                    child: customRadioButton('Passport', 3,
                        onPressed: () => widget.radio.select(3)),
                  ),
                  SizedBox(
                    width: size.width * 0.43,
                    child: customRadioButton('Voters Card', 4,
                        onPressed: () => widget.radio.select(4)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customRadioButton(String text, int index, {void Function()? onPressed}) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE8E8E8)),
              borderRadius: BorderRadius.circular(40),
            ),
            child: (index == widget.radio.value)
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
        const SizedBox(width: 5),
        Text(text, style: style(FontWeight.w600, 16, textColorBlack))
      ],
    );
  }
}
