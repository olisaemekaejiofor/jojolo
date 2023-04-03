import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

class TagCard extends StatelessWidget {
  final String tag;
  final String number;
  final VoidCallback onTap;
  const TagCard({Key? key, required this.tag, required this.onTap, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: textButtonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                tag,
                style: style(FontWeight.w600, 16, fixedBottomColor),
              ),
              const Spacer(),
              Text(
                number,
                style: style(FontWeight.w600, 16, fixedBottomColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
