// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jojolo_mobile/src/utils/date_string.dart';
import 'package:like_button/like_button.dart';

import '../../../controllers/home_controllers/forum_controller.dart';
import '../../../data/models/post_models.dart';
import '../../../di/service_locator.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';
import '../../screens/home_screens/forum/comment_page.dart';
import '../app_widgets/app_flush.dart';

class CommentCard extends StatefulWidget {
  final CommentElement post;
  final bool myPost;
  final VoidCallback onTap;
  final VoidCallback like;
  final Future<bool?> Function(bool) likePost;
  final TextEditingController controller;
  final bool liked;
  final bool? load;
  final VoidCallback callBack;
  final VoidCallback? reply;
  final VoidCallback? show;
  final bool? comment;
  const CommentCard({
    Key? key,
    required this.post,
    required this.myPost,
    required this.onTap,
    required this.like,
    required this.likePost,
    required this.controller,
    required this.liked,
    this.load,
    this.reply,
    this.show,
    this.comment,
    required this.callBack,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool show = false;
  convert(String? dat) {
    var u = (dat != '')
        ? (dat!.contains(RegExp(
                r'[a-zA-Z]+(\s+([a-zA-Z]+\s+)+)\d\d\s\d\d\d\d\s([0-9]+(:[0-9]+)+)\s[a-zA-Z]+([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?\s\(.*\)')))
            ? dat
            : 'done'
        : "Tue Jun 28 2022 16:37:57 GMT+0100 (West Africa Standard Time)";
    var mnths = {
      'Jan': "01",
      'Feb': "02",
      'Mar': "03",
      'Apr': "04",
      'May': "05",
      'Jun': "06",
      'Jul': "07",
      'Aug': "08",
      'Sep': "09",
      'Oct': "10",
      'Nov': "11",
      'Dec': "12"
    };
    if (u == 'done') {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dat!);
    } else {
      var date = u.split(" ");
      return DateTime.parse([date[3], mnths[date[1]], date[2]].join("-") + ' ' + date[4]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (widget.comment == true) ? background : fixedBottomColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(
                name: widget.post.fullName!,
                role: (widget.post.role == null)
                    ? widget.post.rolesDescription!
                    : widget.post.role!,
                image: (widget.post.doctorId == null) ? null : null,
                time: convert(widget.post.timeMoment ?? ''),
                onTap: widget.onTap,
              ),
              Divider(
                color: textColorGrey.withOpacity(0.5),
                thickness: 0.4,
              ),
              body(description: widget.post.comments!),
              action(
                comments: widget.post.replies.length.toString(),
                likes: widget.post.likes.length,
                sharePost: () async {
                  await FlutterShare.share(
                    title: 'Check out my post on Jojolo',
                    text:
                        'Check out a post on Jojolo.\nClick on this link to view the post\n',
                    linkUrl: 'https://jojolo.netlify.app/forum/post/' + widget.post.id!,
                  );
                },
                reply: () {
                  setState(() => show = true);
                  showModalBottomSheet(
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
                        final ForumController c = serviceLocator<ForumController>();
                        return ReplyComment(
                          load: load,
                          controller: widget.controller,
                          reply: true,
                          title: widget.post.fullName!,
                          onTap: () async {
                            setState(() {
                              load = true;
                            });

                            var i = await c.replyPost(widget.post.postId!,
                                widget.controller.text, widget.post.id!);
                            if (i == 'done') {
                              widget.controller.clear();
                              widget.callBack();
                              setState(() {
                                load = false;
                                Navigator.pop(context);
                                showFlush(
                                  context,
                                  message: 'Replied successfully',
                                  image: 'assets/Active2.svg',
                                  color: greenColor,
                                );
                              });
                            } else {
                              load = false;
                              Navigator.pop(context);
                              showFlush(
                                context,
                                message: 'Reply failed',
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
                },
                like: widget.likePost,
                liked: widget.liked,
              ),
              Visibility(
                visible: show,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Replies:",
                        style: style(FontWeight.bold, 16, textColorBlack),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          show = false;
                        }),
                        child: Text(
                          'Hide replies',
                          style: style(FontWeight.w600, 12, tabColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Visibility(
                    visible: show,
                    child: Column(
                      children: List.generate(
                        widget.post.replies.length,
                        (index) => Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (widget.comment == true)
                                      ? background
                                      : fixedBottomColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    header(
                                      name: widget.post.replies[index].reply!.fullName!,
                                      role:
                                          (widget.post.replies[index].reply!.role == null)
                                              ? widget.post.replies[index].reply!
                                                  .rolesDescription!
                                              : widget.post.replies[index].reply!.role!,
                                      image:
                                          (widget.post.replies[index].reply!.doctorId ==
                                                  null)
                                              ? null
                                              : null,
                                      time: convert(widget
                                              .post.replies[index].reply!.timeMoment ??
                                          "Tue May 31 2022 11:19:57 GMT+0100 (West Africa Standard Time)"),
                                      onTap: widget.onTap,
                                    ),
                                    Divider(
                                      color: textColorGrey.withOpacity(0.5),
                                      thickness: 0.4,
                                    ),
                                    body(
                                        description:
                                            widget.post.replies[index].reply!.reply!),
                                    action(
                                      reply: () {
                                        setState(() => show = true);
                                        showModalBottomSheet(
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
                                              final ForumController c =
                                                  serviceLocator<ForumController>();
                                              return ReplyComment(
                                                load: load,
                                                controller: widget.controller,
                                                reply: true,
                                                title: widget
                                                    .post.replies[index].reply!.fullName!,
                                                onTap: () async {
                                                  setState(() {
                                                    load = true;
                                                  });

                                                  var i = await c.replyPost(
                                                      widget.post.postId!,
                                                      widget.controller.text,
                                                      widget.post.id!);
                                                  if (i == 'done') {
                                                    widget.controller.clear();
                                                    widget.callBack();
                                                    setState(() {
                                                      load = false;
                                                      Navigator.pop(context);
                                                      showFlush(
                                                        context,
                                                        message: 'Replied successfully',
                                                        image: 'assets/Active2.svg',
                                                        color: greenColor,
                                                      );
                                                    });
                                                  } else {
                                                    load = false;
                                                    Navigator.pop(context);
                                                    showFlush(
                                                      context,
                                                      message: 'Reply failed',
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
                                      },
                                      comments: ' ',
                                      likes: widget.post.replies[index].likes.length,
                                      sharePost: () async {
                                        await FlutterShare.share(
                                          title: 'Check out my post on Jojolo',
                                          text:
                                              'Check out a post on Jojolo.\nClick on this link to view the post\n',
                                          linkUrl:
                                              'https://jojolo.netlify.app/forum/post/' +
                                                  widget.post.replies[index].id!,
                                        );
                                      },
                                      liked: false,
                                    ),
                                    Divider(
                                      color: textColorGrey.withOpacity(0.5),
                                      thickness: 0.4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget action({
  required int? likes,
  required String comments,
  Future<bool?> Function(bool)? like,
  VoidCallback? sharePost,
  VoidCallback? reply,
  required bool liked,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: Row(
      children: [
        (comments != '')
            ? GestureDetector(
                onTap: reply,
                child: rowIcon(
                  '',
                  '$comments reply',
                  style: style(FontWeight.w600, 14, textColorBlack),
                ),
              )
            : Container(),
        (comments == '') ? const SizedBox() : const Spacer(),
        LikeButton(
          isLiked: liked,
          size: 15,
          likeBuilder: (isLiked) {
            return SvgPicture.asset(
              'assets/thumb up.svg',
              color: isLiked ? tabColor : null,
            );
          },
          onTap: like,
          likeCount: likes,
        ),
        const Spacer(),
        GestureDetector(
          onTap: sharePost,
          child: rowIcon(
            'assets/share 2.svg',
            'share',
            style: style(FontWeight.w600, 14, textColorBlack),
          ),
        ),
      ],
    ),
  );
}

Widget rowIcon(String image, String label,
    {double? width, double? iconSize, TextStyle? style, Color? color}) {
  return Row(
    children: [
      SvgPicture.asset(
        image,
        width: iconSize ?? 15,
        color: color,
      ),
      SizedBox(width: width ?? 3),
      Text(
        label,
        style: style,
      ),
    ],
  );
}

Widget body({
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          description,
          style: style(FontWeight.w600, 16, textColorBlack),
        ),
      ],
    ),
  );
}

Widget header({
  required String name,
  required String role,
  String? image,
  required DateTime time,
  required VoidCallback onTap,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundColor: const Color(0xff617B7E),
          radius: 15,
          child: Center(
              child: SvgPicture.asset(
            'assets/account 1.svg',
            height: 20,
            color: fixedBottomColor,
          )),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: style(FontWeight.w700, 16, textColorBlack),
          ),
          Row(
            children: [
              Text(
                role + ' . ',
                style: style(FontWeight.normal, 14, textColorBlack),
              ),
              Text(
                dateDate(time),
                style: style(FontWeight.normal, 14, textColorBlack),
              ),
            ],
          ),
        ],
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.more_vert,
            size: 20,
            color: textColorBlack,
          ),
        ),
      ),
    ],
  );
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
                        'assets/delete 2.svg',
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
