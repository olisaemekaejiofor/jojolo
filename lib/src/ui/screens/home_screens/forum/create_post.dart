import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/auth_controls.dart';
import '../../../widgets/app_widgets/bottom_sheet.dart';
import '../../../widgets/app_widgets/buttons.dart';
import '../../../widgets/app_widgets/custom_radio.dart';
import '../../../widgets/app_widgets/text_fields.dart';
import '/src/controllers/home_controllers/forum_controller.dart';
import '../../../widgets/app_widgets/upload_cancel_button.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';

class CreatePost extends StatefulWidget {
  static const routeName = 'create-post';
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final ForumController controller = serviceLocator<ForumController>();
  List<String> list = [];

  void getmylist() async {
    list = await controller.getList();
  }

  @override
  void initState() {
    getmylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(ForumController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ForumController>(
        builder: (context, controller, _) {
          Size size = MediaQuery.of(context).size;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              lauthControl('New Post', image: 'hello'),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: CustomTextField(
                          controller: controller.title,
                          label: 'Title of Post',
                          error: 'error',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: CustomTextField(
                          controller: controller.comment,
                          label: 'Content of Post',
                          error: 'error',
                          height: 120,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFieldBottomSheet(
                          label: 'Select Tag(s)',
                          list: list,
                          controller: controller.tag,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => controller.selectImage(),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: DottedBorder(
                                      child: const Center(
                                        child: Icon(Icons.add,
                                            size: 15, color: textColorBlack),
                                      ),
                                      borderType: BorderType.RRect,
                                      strokeWidth: 1,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [5, 2],
                                      color: bottomNavIcon,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text('Add Image',
                                      style: style(FontWeight.w600, 14, textColorBlack))
                                ],
                              ),
                            ),
                            const Spacer(),
                            customRadioButton(
                              'Post Anonymously?',
                              1,
                              controller.value,
                              onPressed: () {
                                setState(() {
                                  if (controller.value == 1) {
                                    controller.value = 0;
                                  } else {
                                    controller.value = 1;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      (controller.postImage.isNotEmpty)
                          ? Container(
                              padding: const EdgeInsets.only(left: 25),
                              height: 150,
                              width: size.width * 1,
                              child: ListView.builder(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.postImage.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20)),
                                          // width: size.width * 0.3,
                                          child: Image.file(
                                            File(controller.postImage[index]!),
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        UploadCancel(onTap: () => controller.clear(index))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              (controller.buttonLoad == false)
                  ? CustomButton(
                      color: textButtonColor,
                      label: 'Send Post',
                      onTap: () {
                        controller.createPost(context);
                      })
                  : const LoadingCustomButton()
            ],
          );
        },
      ),
    );
  }
}
