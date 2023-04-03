import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

class Filter extends StatelessWidget {
  final VoidCallback filterLatest;
  final VoidCallback filterPopular;
  const Filter({Key? key, required this.filterLatest, required this.filterPopular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.25,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: textColorBlack,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: size.width * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: filterLatest,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Latest',
                        style: style(FontWeight.w600, 18, textColorBlack),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: filterPopular,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Popular',
                        style: style(FontWeight.w600, 18, textColorBlack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
