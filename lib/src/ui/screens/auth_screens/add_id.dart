import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/auth_widgets/radio_button.dart';
import '../../widgets/app_widgets/upload_cancel_button.dart';
import '/src/controllers/auth_controllers/register_controller.dart';
import '/src/di/service_locator.dart';
import '../../widgets/auth_widgets/dotted_border.dart';
import '../../widgets/app_widgets/auth_controls.dart';
import '../../widgets/app_widgets/buttons.dart';

class AddId extends StatefulWidget {
  static const routeName = '/add-id';
  const AddId({Key? key}) : super(key: key);

  @override
  State<AddId> createState() => _AddIdState();
}

class _AddIdState extends State<AddId> {
  final RegisterViewController controller = serviceLocator<RegisterViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              lauthControl('Upload Valid ID Card'),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CustomRadio(radio: controller.radio),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () => controller.imgID(),
                  child: const DottedBorderImg(label: 'Upload Valid ID Card'),
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  width: double.infinity,
                  color: Colors.white,
                  child: (controller.id == null)
                      ? const SizedBox()
                      : Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Image.file(
                              File(controller.id!),
                              height: size.height * 0.25,
                            ),
                            UploadCancel(onTap: () => controller.cancel()),
                          ],
                        ),
                ),
              ),
              const Spacer(),
              (controller.loading == false)
                  ? CustomButton(
                      label: 'Save',
                      onTap: () => controller.updateId(context),
                    )
                  : const LoadingCustomButton()
            ],
          );
        },
      ),
    );
  }
}
