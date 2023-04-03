// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/forum_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:jojolo_mobile/src/ui/widgets/forum_widgets/comment_card.dart';
import 'package:jojolo_mobile/src/ui/widgets/forum_widgets/post_card.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import 'package:provider/provider.dart';
import '../../../../data/api_data/api_data.dart';
import '../../../widgets/app_widgets/bottom_sheet.dart';

class ViewPost extends StatefulWidget {
  static const routeName = 'view-post';

  final String post;

  const ViewPost({Key? key, required this.post}) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    controller.getPost(widget.post);

    super.initState();
  }

  void callBack() {
    controller.getPost(widget.post);
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
          var like = (controller.comLoad == false)
              ? controller.checkLiked(controller.post!.id!)
              : null;

          Size size = MediaQuery.of(context).size;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: AuthBackButton(),
              ),
              const SizedBox(height: 10),
              (controller.comLoad == false)
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                  future: like,
                                  builder: (context, AsyncSnapshot<bool> snapshot) {
                                    bool liked =
                                        snapshot.data == null ? false : snapshot.data!;
                                    Future<bool?> onLikeButtonTapped(bool isLiked) async {
                                      SocketService()
                                          .socket
                                          .emit('notification-message', {
                                        "message": (liked == false)
                                            ? "Liked your post"
                                            : "UnLiked your post",
                                        "name": controller.id,
                                        "recipient":
                                            (controller.post!.caregiverId != null)
                                                ? controller.post!.caregiverId!.id
                                                : controller.post!.doctorId!.id,
                                        "externalModelType":
                                            (controller.type == 'caregiver')
                                                ? "Caregiver"
                                                : "Doctor",
                                        "title": (liked == false)
                                            ? "Like Activity"
                                            : "Unlike Activity"
                                      });
                                      bool done = await controller.like(
                                          controller.post!.id!, context);
                                      if (done == true) {
                                        return !isLiked;
                                      }
                                      return null;
                                    }

                                    return postCard(
                                      context,
                                      comment: true,
                                      post: controller.post!,
                                      myPost: false,
                                      controller: controller.comment,
                                      likePost: onLikeButtonTapped,
                                      more: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        builder: (context) => PostModal(
                                          reportPost: () => showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            builder: (context) => Report(
                                                radio: controller.radio,
                                                id: controller.post!.id!),
                                          ),
                                          savePost: () {
                                            // controller.savePost(controller.post!.id!, context);
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      liked: liked,
                                      load: controller.buttonLoad,
                                    );
                                  }),
                              const Divider(
                                color: textColorGrey,
                                thickness: 0.4,
                              ),
                              (controller.post!.comments.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(
                                          'Comments (${controller.post!.comments.length})',
                                          style:
                                              style(FontWeight.bold, 16, textColorBlack),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(
                                              controller.post!.comments.length,
                                              (index) {
                                                bool like = false;
                                                var commentLike = controller.checkComment(
                                                    controller.post!.id!,
                                                    controller.post!.comments[index].id!);
                                                return FutureBuilder<bool>(
                                                    future: commentLike,
                                                    builder: (context, snapshot) {
                                                      bool liked = snapshot.data == null
                                                          ? false
                                                          : snapshot.data!;
                                                      Future<bool?> onLikeButtonTapped(
                                                          bool isLiked) async {
                                                        bool done =
                                                            await controller.likeComment(
                                                                controller.post!.id!,
                                                                controller.post!
                                                                    .comments[index].id!,
                                                                context);
                                                        if (done == true) {
                                                          return !isLiked;
                                                        }
                                                        return null;
                                                      }

                                                      return CommentCard(
                                                        // context,
                                                        post: controller
                                                            .post!.comments[index],
                                                        myPost: false,
                                                        onTap: () {},
                                                        reply: () => controller.replyPost(
                                                          controller.post!.id!,
                                                          controller.comment.text,
                                                          controller
                                                              .post!.comments[index].id!,
                                                        ),
                                                        callBack: callBack,
                                                        like: () => setState(() {
                                                          like = !like;
                                                        }),
                                                        liked: liked,
                                                        controller: controller.comment,
                                                        likePost: onLikeButtonTapped,
                                                      );
                                                    });
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                          ),
                        ),
                      ),
                    ),
              Container(
                width: double.infinity,
                height: 100,
                color: fixedBottomColor,
                child: Center(
                  child: GestureDetector(
                    onTap: modal,
                    child: Container(
                      height: 50,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                        color: textfieldFillColor,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Add a comment',
                            style: style(FontWeight.w600, 18, textColorGrey),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void modal() => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) => StatefulBuilder(
          builder: (context, setStated) {
            bool load = false;
            return ReplyComment(
              load: load,
              controller: controller.comment,
              reply: false,
              title: controller.post!.title!,
              onTap: () async {
                print('tapped');
                setStated(() {
                  load = true;
                });
                var i = await controller.commentPost(controller.post!.id!);
                if (i == 'done') {
                  controller.comment.clear();
                  Navigator.pop(context);
                  setStated(() {
                    load = false;
                    // Navigator.pop(context);
                    showFlush(
                      context,
                      message: 'Commented successfully',
                      image: 'assets/Active2.svg',
                      color: greenColor,
                    );
                  });
                  controller.getPost(controller.post!.id!);
                } else {
                  load = false;
                  Navigator.pop(context);
                  showFlush(
                    context,
                    message: 'Comment failed',
                    image: 'assets/Active.svg',
                    color: errorColor,
                  );
                }
              },
            );
          },
        ),
        isScrollControlled: true,
      );
}

class ReplyComment extends StatelessWidget {
  final String title;
  final bool reply;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool load;
  const ReplyComment({
    Key? key,
    required this.title,
    required this.reply,
    required this.controller,
    this.onTap,
    required this.load,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: textColorBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: style(FontWeight.w600, 15, textColorBlack),
                      children: [
                        TextSpan(
                            text: (reply == true) ? "Replying to " : "Commenting on "),
                        TextSpan(
                          text: title,
                          style: style(FontWeight.bold, 15, tabColor),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const AuthBackButton(image: 'image'),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(left: 15.0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TextField(
          controller: controller,
          style: style(FontWeight.w600, 17, textColorBlack),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Add a comment',
            hintStyle: style(FontWeight.w600, 17, textColorGrey),
          ),
        ),
      ),
      const Divider(color: textColorGrey),
      Padding(
        padding: EdgeInsets.only(
            right: 15.0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Align(
            child: GestureDetector(
              onTap: onTap,
              child: (load == false)
                  ? Text(
                      (reply == true) ? 'REPLY' : 'COMMENT',
                      style: style(FontWeight.bold, 16, tabColor),
                    )
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                    ),
            ),
            alignment: Alignment.centerRight,
          ),
        ),
      ),
    ]);
  }
}
