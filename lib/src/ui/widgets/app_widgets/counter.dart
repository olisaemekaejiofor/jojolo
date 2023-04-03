import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/src/utils/text_style.dart';
import '/src/utils/colors.dart';
import '../../../utils/notifiers.dart';

class CounterWidget extends StatefulWidget {
  final CounterNotifier counter;
  const CounterWidget({
    Key? key,
    required this.counter,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Years of Expirience',
          style: style(FontWeight.w600, 18, textColorBlack),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            button('minus', onTap: () => widget.counter.decrement()),
            const SizedBox(width: 10),
            ValueListenableBuilder(
              valueListenable: widget.counter,
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: style(FontWeight.w600, 18, textColorBlack),
                );
              },
            ),
            const SizedBox(width: 10),
            button('plus', onTap: () => widget.counter.increment())
          ],
        ),
      ],
    );
  }

  Widget button(String icon, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: backButtonBackground,
        ),
        child: Center(
            child: FaIcon(
          (icon == 'plus') ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
          color: tabColor,
          size: 20,
        )),
      ),
    );
  }
}
