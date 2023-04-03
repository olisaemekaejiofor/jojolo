// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '/src/controllers/home_controllers/forum_controller.dart';
import '/src/di/service_locator.dart';
import 'package:provider/provider.dart';

// import '../../../../data/api_data/api_data.dart';
// import '../../../../data/models/post_models.dart';
import '../../../../utils/colors.dart';
// import '../../../widgets/app_widgets/app_flush.dart';
import '../../../widgets/forum_widgets/post_card.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    super.initState();
    controller.loadMyPosts();
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
          return (controller.myPostsLoad == true)
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
                  onRefresh: () => controller.refreshMyPosts(),
                  color: tabColor,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var like = controller.checkLiked(controller.myPosts[index].id!);

                      return FutureBuilder(
                        future: like,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          bool liked = snapshot.data == null ? false : snapshot.data!;
                          Future<bool?> onLikeButtonTapped(bool isLiked) async {
                            bool done = await controller.like(
                                controller.myPosts[index].id!, context);
                            if (done == true) {
                              return !isLiked;
                            }
                            return null;
                          }

                          return postCard(
                            context,
                            post: controller.myPosts[index],
                            myPost: false,
                            more: () => modal(index, controller.myPosts[index].id!),
                            controller: controller.comment,
                            likePost: onLikeButtonTapped,
                            liked: liked,
                            load: controller.buttonLoad,
                          );
                        },
                      );
                    },
                    itemCount: controller.myPosts.length,
                    padding: const EdgeInsets.all(0),
                  ),
                );
        },
      ),
    );
  }

  void modal(int index, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => MyPostModal(
        deletePost: () => controller.deletePost(
          postId,
          index,
          context,
        ),
      ),
    );
  }
}
