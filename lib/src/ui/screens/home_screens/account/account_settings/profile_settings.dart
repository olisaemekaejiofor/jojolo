import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/app_widgets/buttons.dart';
import '../../../../widgets/app_widgets/text_fields.dart';

class ProfileSettings extends StatefulWidget {
  static const routeName = 'profile-settings';
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getType();
    controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(AccountController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Profile Settings'),
              const SizedBox(height: 20),
              (controller.loading == false)
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              updateProfile(),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: controller.fname,
                                label: 'First Name',
                                error: '',
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: controller.lname,
                                label: 'Last Name',
                                error: '',
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: controller.email,
                                label: 'Email Address',
                                error: 'Please enter a valid email address',
                                type: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: controller.phone,
                                label: 'Phone Number',
                                error: 'Please enter a valid Phone number',
                                type: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              (controller.userType != 'caregiver')
                                  ? CustomTextField(
                                      controller: controller.bio,
                                      label: 'Bio',
                                      error: '',
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(tabColor),
                        ),
                      ),
                    ),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : CustomButton(
                      label: 'Update Profile',
                      onTap: () => controller.update(context),
                    )
            ],
          );
        },
      ),
    );
  }

  Widget updateProfile() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: Color(0xff617B7E),
            shape: BoxShape.circle,
          ),
          child: (controller.path == null)
              ? (controller.image == null)
                  ? Center(
                      child: Text(
                        controller.initial,
                        style: style(
                          FontWeight.bold,
                          30,
                          fixedBottomColor,
                        ),
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            controller.image!,
                          ),
                        ),
                      ),
                    )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(controller.path!),
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => controller.addImage(),
          child: Text(
            'Add Photo',
            style: style(FontWeight.w600, 14, tabColor),
          ),
        )
      ],
    );
  }
}
