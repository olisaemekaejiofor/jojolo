import 'package:flutter/material.dart';
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

class Popular extends StatefulWidget {
  const Popular({
    Key? key,
  }) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    super.initState();
    controller.filterPost('popular');
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
                          Future<bool?> onLikeButtonTapped(bool isLiked) async {
                            bool done = await controller.like(
                                controller.posts[index].id!, context);
                            if (done == true) {
                              return !isLiked;
                            }
                            return null;
                          }

                          bool liked = snapshot.data == null ? false : snapshot.data!;
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
