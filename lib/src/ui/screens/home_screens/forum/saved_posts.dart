import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/forum_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/forum_widgets/saved_post_card.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../widgets/app_widgets/bottom_sheet.dart';

class SavedPost extends StatefulWidget {
  const SavedPost({Key? key}) : super(key: key);

  @override
  State<SavedPost> createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    super.initState();
    controller.loadSaved();
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
          return (controller.savePostLoad == true)
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
                  onRefresh: () => controller.refreshSaved(),
                  color: tabColor,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var like = controller.checkLiked(controller.savedPosts[index].id!);

                      return FutureBuilder(
                        future: like,
                        builder: ((context, AsyncSnapshot<bool> snapshot) {
                          bool liked = snapshot.data == null ? false : snapshot.data!;

                          return savePostCard(
                            context,
                            post: controller
                                .savedPosts[controller.savedPosts.length - index - 1],
                            myPost: false,
                            more: () => modal(
                                controller
                                    .savedPosts[controller.savedPosts.length - index - 1]
                                    .id!,
                                index),
                            controller: controller.comment,
                            like: () {
                              controller.like(
                                  controller
                                      .savedPosts[
                                          controller.savedPosts.length - index - 1]
                                      .id!,
                                  context);
                              setState(() {
                                liked = !liked;
                              });
                            },
                            liked: liked,
                            load: controller.buttonLoad,
                          );
                        }),
                      );
                    },
                    itemCount: controller.savedPosts.length,
                    padding: const EdgeInsets.all(0),
                  ),
                );
        },
      ),
    );
  }

  void modal(String postId, int index) {
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
          isSaved: true,
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
          savePost: () async {
            controller.unSavePost(postId, index, context);
          }),
    );
  }
}
