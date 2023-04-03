import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

class PlanCards extends StatefulWidget {
  final Color color;
  final Color background;
  final String text;
  final List<String> monthly;
  final List<String> yearly;
  final String amount;
  final String amountYear;
  const PlanCards({
    Key? key,
    required this.color,
    required this.background,
    required this.text,
    required this.monthly,
    required this.yearly,
    required this.amount,
    required this.amountYear,
  }) : super(key: key);

  @override
  State<PlanCards> createState() => _PlanCardsState();
}

class _PlanCardsState extends State<PlanCards> {
  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> widgets = <int, Widget>{
      0: tab1(sharedValue),
      1: tab2(sharedValue),
    };
    Map<int, Widget> details = <int, Widget>{
      0: PlanCardDetails(
        details: widget.monthly,
        amount: widget.amount,
        amountYear: widget.amountYear,
        m: true,
      ),
      1: PlanCardDetails(
        details: widget.yearly,
        amount: widget.amountYear,
        amountYear: widget.amountYear,
        m: false,
      ),
    };
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "${widget.text} Plan",
            style: style(FontWeight.bold, 25, widget.color),
          ),
          const SizedBox(height: 10),
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: textButtonColorOpa,
                primary: Colors.transparent,
              ),
            ),
            child: CupertinoSegmentedControl(
              children: widgets,
              onValueChanged: (int val) {
                setState(() {
                  sharedValue = val;
                });
              },
              groupValue: sharedValue,
              selectedColor: widget.color,
              unselectedColor: Colors.white,
              padding: const EdgeInsets.all(10),
            ),
          ),
          SizedBox(child: details[sharedValue])
        ],
      ),
    );
  }

  Widget tab1(int check) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          "Monthly",
          style: style(
            FontWeight.w600,
            18,
            (check == 0) ? fixedBottomColor : textColorBlack,
          ),
        ),
      ),
    );
  }

  Widget tab2(int check) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          "Yearly",
          style: style(
            FontWeight.w600,
            18,
            (check == 0) ? textColorBlack : fixedBottomColor,
          ),
        ),
      ),
    );
  }
}

class PlanCardDetails extends StatelessWidget {
  final List<String> details;
  final String amount;
  final String amountYear;
  final bool m;
  const PlanCardDetails(
      {Key? key,
      required this.details,
      required this.amount,
      required this.amountYear,
      required this.m})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
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
              style: style(FontWeight.bold, 20, textColorBlack),
              children: [
                TextSpan(text: amount),
                TextSpan(
                  text: (m == true) ? '/Month' : '/Year',
                  style: style(FontWeight.normal, 13, textColorBlack),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: details.map((e) => rowDetail(e)).toList(),
          )
        ],
      ),
    );
  }

  Widget rowDetail(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const Icon(Icons.check, color: textButtonColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: style(FontWeight.w600, 16, textColorBlack),
          )
        ],
      ),
    );
  }
}
