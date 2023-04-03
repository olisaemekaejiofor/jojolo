import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color? color;
  final void Function()? onTap;
  final bool? show;
  const CustomButton({Key? key, required this.label, this.onTap, this.show, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        color: show == true ? Colors.transparent : fixedBottomColor,
        child: Center(
          child: Container(
            height: 50,
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: color ?? tabColor,
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Center(
              child: Text(
                label,
                style: style(FontWeight.bold, 16, fixedBottomColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDoubleButton extends StatelessWidget {
  final String label;
  final String label2;
  final void Function()? onTap;
  final VoidCallback? onTap2;
  const CustomDoubleButton({
    Key? key,
    required this.label,
    this.onTap,
    required this.label2,
    this.onTap2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 150,
      color: fixedBottomColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: tabColor,
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Center(
                child: Text(
                  label,
                  style: style(FontWeight.bold, 16, fixedBottomColor),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap2 ?? () => Navigator.pop(context),
            child: Container(
              height: 50,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: backButtonBackground,
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Center(
                child: Text(
                  label2,
                  style: style(FontWeight.bold, 16, tabColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingCustomButton extends StatelessWidget {
  final bool? show;
  const LoadingCustomButton({Key? key, this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 100,
      color: (show == true) ? Colors.transparent : fixedBottomColor,
      child: Center(
        child: Container(
          height: 50,
          width: size.width * 0.85,
          decoration: BoxDecoration(
            color: tabColor,
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(fixedBottomColor),
          )),
        ),
      ),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final String? image;
  const AuthBackButton({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: backButtonBackground,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: (image == '' || image == null)
              ? const Icon(Icons.arrow_back, color: tabColor, size: 20)
              : SvgPicture.asset('assets/x.svg', width: 20),
        ),
      ),
    );
  }
}
