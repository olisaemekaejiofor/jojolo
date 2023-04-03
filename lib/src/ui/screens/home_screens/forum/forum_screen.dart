// ignore_for_file: prefer_is_empty, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/forum/popular.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/notification_screen.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import 'package:provider/provider.dart';

import '../../../../data/api_data/api_data.dart';
import '../../../widgets/app_widgets/tab.dart';
import '../../../widgets/forum_widgets/filter.dart';
import '/src/utils/text_style.dart';
import '/src/controllers/home_controllers/forum_controller.dart';
import '/src/ui/screens/home_screens/forum/tags_page.dart';
import '/src/ui/screens/home_screens/forum/feeds_page.dart';
import '/src/ui/screens/home_screens/forum/saved_posts.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import '/src/utils/bottom_navigation.dart';
import 'my_posts_page.dart';
import '../../../widgets/app_widgets/page_item.dart';

class Forum extends StatefulWidget {
  static const routeName = 'forum';
  const Forum({Key? key}) : super(key: key);

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final ForumController controller = serviceLocator<ForumController>();

  @override
  void initState() {
    controller.load();
    SocketService().createSocketConnection();
    controller.listenToSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          SystemNavigator.pop();
          return true;
        } else {
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(index: 1),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'create-post'),
          backgroundColor: textButtonColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/edit form.svg',
                width: 28,
              ),
            ),
          ),
        ),
        body: _buildBody(controller),
      ),
    );
  }

  _buildBody(ForumController controller) {
    return ChangeNotifierProvider<ForumController>(
      create: (context) => controller,
      child: Consumer<ForumController>(
        builder: (context, controller, _) {
          List<Widget> widgets = [
            (controller.filter == 'latest') ? const Feeds() : const Popular(),
            const MyPosts(),
            const SavedPost(),
            TagPage(tags: controller.tagP, onRefresh: controller.refreshTags)
          ];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  children: [
                    Text("Forum", style: style(FontWeight.bold, 25, textColorBlack)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'search'),
                      child: SvgPicture.asset('assets/search.svg', width: 25),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: (context) => Filter(
                          filterLatest: () {
                            setState(() {
                              controller.filter = 'latest';
                            });
                            Navigator.pop(context);
                          },
                          filterPopular: () {
                            setState(() {
                              controller.filter = 'popular';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/filter.svg',
                        width: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CustomPageRoute(
                          child: NotificationScreen(
                            notify: controller.notifications,
                          ),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset('assets/notification on.svg', width: 25),
                          Positioned(
                            right: -2.5,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: BoxDecoration(
                                color: (controller.unread == 0)
                                    ? Colors.transparent
                                    : textButtonColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  controller.unread.toString(),
                                  style: style(
                                      FontWeight.w600,
                                      10,
                                      (controller.unread == 0)
                                          ? Colors.transparent
                                          : textColorBlack),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                HomeTab(
                  pageController: controller.controller,
                  tabController: controller.tabBarController,
                  list: controller.list,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.controller,
                    itemCount: widgets.length,
                    itemBuilder: (context, index) {
                      return PageItem(
                        index,
                        child: widgets[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
