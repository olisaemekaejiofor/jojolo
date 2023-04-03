import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/upload_cancel_button.dart';

import 'package:provider/provider.dart';

import '../../widgets/app_widgets/auth_controls.dart';
import '../../widgets/auth_widgets/dotted_border.dart';
import '/src/controllers/auth_controllers/register_controller.dart';
import '/src/di/service_locator.dart';
import '../../widgets/app_widgets/buttons.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

class AddLicense extends StatefulWidget {
  static const routeName = '/add-license';
  const AddLicense({Key? key}) : super(key: key);

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
  final RegisterViewController controller = serviceLocator<RegisterViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(RegisterViewController controller) {
    return ChangeNotifierProvider<RegisterViewController>(
      create: (context) => controller,
      child: Consumer<RegisterViewController>(
        builder: (context, controller, _) {
          Size size = MediaQuery.of(context).size;
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Upload Medical License(s)'),
              const SizedBox(height: 40),
              Text(
                'Please Provide a Valid Medical Licence For Each\nCountry Of Your Practice',
                style: style(FontWeight.w700, 17, textColorBlack),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                    onTap: () => controller.imgLicense(),
                    child: const DottedBorderImg(label: 'Upload Medical License')),
              ),
              const Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: (controller.license == null)
                        ? const SizedBox()
                        : Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Image.file(
                                File(controller.license!),
                                height: size.height * 0.25,
                              ),
                              UploadCancel(onTap: () => controller.cancel()),
                            ],
                          ),
                  ),
                ),
              ),
              const Spacer(),
              (controller.loading == false)
                  ? CustomButton(
                      label: 'Save',
                      onTap: () => controller.updateLicense(context),
                    )
                  : const LoadingCustomButton()
            ],
          );
        },
      ),
    );
  }
}
