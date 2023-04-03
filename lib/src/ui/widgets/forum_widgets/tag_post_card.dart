// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/data/models/tag_post_models.dart';
import 'package:like_button/like_button.dart';

import '../../../controllers/home_controllers/forum_controller.dart';
import '../../../di/service_locator.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_string.dart';
import '../../../utils/page_route.dart';
import '../../../utils/text_style.dart';
import '../../screens/home_screens/forum/comment_page.dart';
import '../app_widgets/app_flush.dart';

Widget tagPostCard(
  BuildContext context, {
  required TagPost post,
  required bool myPost,
  required VoidCallback more,
  required bool liked,
  required bool load,
  bool? comment,
  required Future<bool?> Function(bool) likePost,
  required TextEditingController controller,
}) {
  return StatefulBuilder(
      builder: (context, setState) => Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (comment == true) ? background : fixedBottomColor,
            ),
            child: Column(
              children: [
                header(
                  name: (post.postAnonymously == true)
                      ? 'Annonymous'
                      : (post.doctorId.isEmpty)
                          ? post.caregiverId[0].fullName!
                          : post.doctorId[0].fullName!,
                  role: (post.doctorId.isEmpty) ? 'Caregiver' : post.doctorId[0].role!,
                  image: (post.doctorId.isEmpty) ? null : null,
                  time: dateDate(post.updatedAt!),
                  onTap: more,
                ),
                const Divider(
                  color: textColorGrey,
                  thickness: 0.4,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    CustomPageRoute(
                      child: ViewPost(post: post.id!),
                    ),
                  ),
                  child: body(
                    image: post.imageUrl,
                    description: post.content!,
                    post: post.title!,
                  ),
                ),
                (post.tags == null) ? Container() : tag(post.tags!.tagName!),
                action(
                  comments: post.comments.length,
                  likes: post.likes.length,
                  sharePost: () async {
                    await FlutterShare.share(
                      title: 'Check out my post on Jojolo',
                      text:
                          'Check out a post on Jojolo.\nClick on this link to view the post\n',
                      linkUrl: 'https://jojolo-secure.netlify.app/forum/post/' + post.id!,
                    );
                  },
                  comment: (comment == true)
                      ? () => showModalBottomSheet(
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
                                  controller: controller,
                                  reply: false,
                                  title: post.title!,
                                  onTap: () async {
                                    print('tapped');
                                    setStated(() {
                                      load = true;
                                    });
                                    var i = await c.commentPost(post.id!);
                                    if (i == 'done') {
                                      setStated(() {
                                        load = false;
                                        Navigator.pop(context);
                                        showFlush(
                                          context,
                                          message: 'Commented successfully',
                                          image: 'assets/Active.svg',
                                          color: greenColor,
                                        );
                                      });
                                    } else {
                                      load = false;
                                      Navigator.pop(context);
                                      showFlush(
                                        context,
                                        message: 'Comment failed',
                                        image: 'assets/Active2.svg',
                                        color: errorColor,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            isScrollControlled: true,
                          )
                      : () => Navigator.push(
                            context,
                            CustomPageRoute(
                              child: ViewPost(post: post.id!),
                            ),
                          ),
                  like: likePost,
                  liked: liked,
                ),
              ],
            ),
          ));
}

Widget tag(String tag) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: textButtonColor,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/tag.svg',
              color: fixedBottomColor,
              width: 20,
            ),
            const SizedBox(width: 5),
            Text(
              tag,
              style: style(FontWeight.w700, 14, fixedBottomColor),
            )
          ],
        ),
      ),
      const Expanded(
        child: SizedBox(
          width: double.infinity,
        ),
      )
    ],
  );
}

Widget action({
  required int? likes,
  required int comments,
  VoidCallback? sharePost,
  VoidCallback? comment,
  Future<bool?> Function(bool)? like,
  required bool liked,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        GestureDetector(
          onTap: comment,
          child: rowIcon(
            'assets/square.svg',
            '$comments',
            style: style(FontWeight.w600, 14, textColorBlack),
          ),
        ),
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

Widget rowIcon(
  String image,
  String label, {
  double? width,
  double? iconSize,
  TextStyle? style,
  Color? color,
}) {
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
  required List<dynamic> image,
  required String post,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post,
          style: style(FontWeight.bold, 18, textColorBlack),
        ),
        const SizedBox(height: 10),
        (image.isNotEmpty) ? Image.network(image[0]) : Container(),
        const SizedBox(height: 10),
        Text(
          description,
          style: style(FontWeight.w600, 14.5, textColorBlack),
        ),
      ],
    ),
  );
}

Widget header({
  required String name,
  required String role,
  String? image,
  required String time,
  required VoidCallback onTap,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundColor: const Color(0xff617B7E),
          radius: 22,
          child: Center(
              child: SvgPicture.asset(
            'assets/account 1.svg',
            height: 30,
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
            style: style(FontWeight.w700, 17, textColorBlack),
          ),
          Row(
            children: [
              Text(
                role + ' . ',
                style: style(FontWeight.normal, 15, textColorBlack),
              ),
              Text(
                time,
                style: style(FontWeight.normal, 15, textColorBlack),
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
            size: 25,
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
