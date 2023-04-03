import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class UploadCancel extends StatelessWidget {
  final VoidCallback onTap;
  const UploadCancel({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10,
      right: -10,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: bottomNavIcon,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.close,
              color: fixedBottomColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
