// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/data/storage_data/storage_data.dart';
import '../../../../data/api_data/api_data.dart';
import '../../../widgets/app_widgets/bottom_sheet.dart';
import '/src/controllers/home_controllers/forum_controller.dart';
import 'package:provider/provider.dart';

// import '../../../../data/api_data/api_data.dart';
// import '../../../../data/models/post_models.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/colors.dart';
// import '../../../widgets/app_widgets/app_flush.dart';
// import '../../../widgets/app_widgets/bottom_sheet.dart';
import '../../../widgets/forum_widgets/post_card.dart';

class Feeds extends StatefulWidget {
  const Feeds({
    Key? key,
  }) : super(key: key);

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    super.initState();
    Provider.of<AccountController>(context, listen: false).getSubPlans();
    controller.loadPost();
    controller.listenToSocket();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(controller);
  }

  _buildBody(ForumController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ForumController>(
        builder: (context, controller, _) {
          return (controller.postsLoad == true)
              ? const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => controller.refreshPosts(),
                  color: tabColor,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var like = controller.checkLiked(controller.posts[index].id!);

                      return FutureBuilder(
                        future: like,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          bool liked = snapshot.data == null ? false : snapshot.data!;
                          Future<bool?> onLikeButtonTapped(bool isLiked) async {
                            final Storage store = serviceLocator<Storage>();
                            String? name = await store.getName();
                            SocketService().socket.emit('notification-message', {
                              "message": (liked == false)
                                  ? " $name Liked your post"
                                  : "$name UnLiked your post",
                              "name": controller.id,
                              "recipient": (controller.posts[index].caregiverId != null)
                                  ? controller.posts[index].caregiverId!.id
                                  : controller.posts[index].doctorId!.id,
                              "externalModelType": (controller.type == 'caregiver')
                                  ? "Caregiver"
                                  : "Doctor",
                              "title":
                                  (liked == false) ? "Like Activity" : "Unlike Activity"
                            });
                            bool done = await controller.like(
                                controller.posts[index].id!, context);

                            if (done == true) {
                              return !isLiked;
                            }
                            return null;
                          }

                          return postCard(
                            context,
                            post: controller.posts[index],
                            myPost: false,
                            more: () => modal(controller.posts[index].id!),
                            controller: controller.comment,
                            likePost: onLikeButtonTapped,
                            liked: liked,
                            load: controller.buttonLoad,
                          );
                        },
                      );
                    },
                    itemCount: controller.posts.length,
                    padding: const EdgeInsets.all(0),
                  ),
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
