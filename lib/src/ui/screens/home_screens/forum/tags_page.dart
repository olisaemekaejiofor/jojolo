import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/forum_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/forum_widgets/tag_post_card.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../widgets/app_widgets/bottom_sheet.dart';
import '../../../widgets/forum_widgets/tag_card.dart';

class TagPage extends StatefulWidget {
  final List<dynamic> tags;
  final Future<void> Function() onRefresh;
  const TagPage({Key? key, required this.tags, required this.onRefresh})
      : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: tabColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: widget.tags.length,
        itemBuilder: (context, index) {
          return TagCard(
            tag: widget.tags[index]['tag'],
            number: widget.tags[index]['postN'],
            onTap: () => Navigator.push(
              context,
              CustomPageRoute(
                child: TagNamePage(
                  name: widget.tags[index]['tag'],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TagNamePage extends StatefulWidget {
  final String name;
  const TagNamePage({Key? key, required this.name}) : super(key: key);

  @override
  State<TagNamePage> createState() => _TagNamePageState();
}

class _TagNamePageState extends State<TagNamePage> {
  final ForumController controller = serviceLocator<ForumController>();
  @override
  void initState() {
    controller.loadTags(widget.name);
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
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl(widget.name),
              const SizedBox(height: 20),
              (controller.tagsLoad == true)
                  ? const Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var like =
                              controller.checkLiked(controller.tagsPost[index].id!);

                          return FutureBuilder(
                            future: like,
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              bool liked = snapshot.data == null ? false : snapshot.data!;
                              Future<bool?> onLikeButtonTapped(bool isLiked) async {
                                // SocketService().socket.emit('notification-message', {
                                //   "message": (liked == false)
                                //       ? "Liked your post"
                                //       : "UnLiked your post",
                                //   "name": controller.id,
                                //   "recipient":
                                //       (controller.tagsPost[index].caregiverId.isEmpty)
                                //           ? controller.tagsPost[index].
                                //           : controller.tagsPost[index].doctorId[0],
                                //   "externalModelType": (controller.type == 'caregiver')
                                //       ? "Caregiver"
                                //       : "Doctor",
                                //   "title": (liked == false)
                                //       ? "Like Activity"
                                //       : "Unlike Activity"
                                // });
                                bool done = await controller.like(
                                    controller.tagsPost[index].id!, context);
                                if (done == true) {
                                  return !isLiked;
                                }
                                return null;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: tagPostCard(
                                  context,
                                  post: controller.tagsPost[index],
                                  myPost: false,
                                  more: () => modal(controller.tagsPost[index].id!),
                                  controller: controller.comment,
                                  likePost: onLikeButtonTapped,
                                  liked: liked,
                                  load: controller.buttonLoad,
                                ),
                              );
                            },
                          );
                        },
                        itemCount: controller.tagsPost.length,
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  void modal(String postId) {
    showModalBottomSheet(
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
          builder: (context) => StatefulBuilder(builder: (context, setStae) {
            return Report(
              radio: controller.radio,
              id: postId,
            );
          }),
        ),
        savePost: () async => controller.savePost(postId, context),
      ),
    );
  }
}
