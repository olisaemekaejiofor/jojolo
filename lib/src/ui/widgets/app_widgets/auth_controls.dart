import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';
import 'buttons.dart';

Widget authControl(BuildContext ctx, String route, String label, {bool? show}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      children: [
        (show == true || show == null) ? const AuthBackButton() : Container(),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pushNamed(ctx, route),
          child: Text(
            label,
            style: style(FontWeight.bold, 20, textButtonColor),
          ),
        ),
      ],
    ),
  );
}

Widget dauthControl(BuildContext ctx, String route, String label, String label2) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AuthBackButton(),
        Text(
          label2,
          style: style(FontWeight.bold, 18, textColorBlack),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(ctx, route),
          child: Text(
            label,
            style: style(FontWeight.bold, 20, textButtonColor),
          ),
        ),
      ],
    ),
  );
}

Widget lauthControl(String label2, {String? image}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      children: [
        AuthBackButton(
          image: image,
        ),
        const Spacer(),
        Text(
          label2,
          style: style(FontWeight.bold, 20, textColorBlack),
        ),
        const SizedBox(width: 40),
        const Spacer(),
      ],
    ),
  );
}
