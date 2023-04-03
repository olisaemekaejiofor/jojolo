// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/forum_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../utils/notifiers.dart';
import '../../../utils/text_style.dart';
import '../forum_widgets/post_card.dart';
import 'buttons.dart';

class TextFieldBottomSheet extends StatefulWidget {
  final String label;
  final List<String> list;
  final TextEditingController controller;
  final void Function(String value) onChanged;
  const TextFieldBottomSheet(
      {Key? key,
      required this.label,
      required this.list,
      required this.controller,
      required this.onChanged})
      : super(key: key);

  @override
  State<TextFieldBottomSheet> createState() => _TextFieldBottomSheetState();
}

class _TextFieldBottomSheetState extends State<TextFieldBottomSheet> {
  String selected = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: style(FontWeight.w600, 16, textColorBlack),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              builder: (context) => Container(
                width: double.infinity,
                height: (widget.list.length < 4)
                    ? size.height * 0.3
                    : (widget.list.length == 4)
                        ? size.height * 0.37
                        : size.height * 0.67,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        width: size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.list.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  // selected = widget.list[index];
                                  widget.controller.text = widget.list[index];
                                  // debugPrint(widget.controller.text);
                                });

                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  widget.list[index],
                                  style: style(FontWeight.w600, 20, textColorBlack),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          child: Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                color: textfieldFillColor, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    child: TextField(
                      readOnly: true,
                      controller: widget.controller,
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                        widget.onChanged(selected);
                      },
                      decoration: const InputDecoration(border: InputBorder.none),
                      style: style(FontWeight.w600, 16, textColorBlack),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: textColorBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void bottom(BuildContext ctx) {
  showModalBottomSheet(
    context: ctx,
    backgroundColor: fixedBottomColor,
    barrierColor: Colors.black.withOpacity(0.4),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 20),
            Text(
              'Create an account to get full access\nto Jojolo’s services',
              style: style(FontWeight.bold, 22, textColorBlack),
              textAlign: TextAlign.center,
            ),
            CustomButton(
              label: 'Continue with Email',
              onTap: () => Navigator.pushNamed(ctx, 'register'),
            ),
            RichText(
              text: TextSpan(
                style: style(FontWeight.bold, 14, textColorBlack),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                      text: 'Login', style: style(FontWeight.bold, 14, textButtonColor)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

class PostModal extends StatelessWidget {
  final VoidCallback savePost;
  final VoidCallback reportPost;
  final bool? isSaved;
  const PostModal({
    Key? key,
    required this.savePost,
    required this.reportPost,
    this.isSaved,
  }) : super(key: key);

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
                    onTap: savePost,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: rowIcon(
                        'assets/bookmark.svg',
                        (isSaved == true) ? 'Unsave Post' : 'Save Post',
                        width: 15,
                        iconSize: 20,
                        style: style(FontWeight.w600, 18, textColorBlack),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: reportPost,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: rowIcon(
                        'assets/flag.svg',
                        'Report Post',
                        width: 15,
                        iconSize: 20,
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

class MyPostModal extends StatelessWidget {
  final VoidCallback deletePost;
  const MyPostModal({Key? key, required this.deletePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.15,
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
                    onTap: deletePost,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: rowIcon(
                        'assets/delete.svg',
                        'Delete Post',
                        width: 15,
                        iconSize: 20,
                        color: errorColor,
                        style: style(FontWeight.w600, 18, errorColor),
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

class Report extends StatefulWidget {
  final String id;
  final RadioNotifier radio;
  const Report({Key? key, required this.radio, required this.id}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final ForumController controller = serviceLocator<ForumController>();
  int value = 0;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ForumController>(
        builder: (context, controller, _) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: const BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: textColorBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              'Report Post',
                              style: style(FontWeight.bold, 20, textColorBlack),
                            ),
                            const Spacer(),
                            const AuthBackButton(image: 'image')
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Why are you reporting this post?',
                            style: style(FontWeight.bold, 16, textColorBlack),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      customRadioButton('Bullying or harassment', 1,
                          onPressed: () => setState(() {
                                value = 1;
                              })),
                      customRadioButton('Spreading hate speech', 2,
                          onPressed: () => setState(() {
                                value = 2;
                              })),
                      customRadioButton('Inciting violence & dangerous activities', 3,
                          onPressed: () => setState(() {
                                value = 3;
                              })),
                      customRadioButton('Passing misinformation', 4,
                          onPressed: () => setState(() {
                                value = 4;
                              })),
                    ],
                  ),
                ),
                (loading == true)
                    ? const LoadingCustomButton()
                    : CustomButton(
                        label: 'Submit Report',
                        onTap: () async {
                          if (value == 0) {
                          } else {
                            setState(() {
                              loading = true;
                            });
                            bool check = await controller.reportPost(widget.id);
                            if (check == true) {
                              setState(() {
                                loading = false;
                              });
                              showFlush(
                                context,
                                message: 'Post has been Reported',
                                image: 'assets/Active2.svg',
                                color: greenColor,
                              );
                            } else {
                              showFlush(
                                context,
                                message: 'Unable to report post',
                                image: 'assets/Active.svg',
                                color: errorColor,
                              );
                              setState(() {
                                loading = false;
                              });
                            }
                            // Future.delayed(const Duration(seconds: 3), () {
                            //   setState(() {
                            //     loading = false;
                            //   });
                            // });
                          }
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget customRadioButton(String text, int index, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Row(
        children: [
          Text(text, style: style(FontWeight.w600, 16, textColorBlack)),
          const Spacer(),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE8E8E8)),
                borderRadius: BorderRadius.circular(40),
              ),
              child: (index == value)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: textButtonColor,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      width: double.infinity,
                      height: double.infinity,
                      child: const Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      )))
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
