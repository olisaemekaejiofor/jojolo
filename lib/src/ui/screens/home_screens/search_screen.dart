import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';
import '../../widgets/app_widgets/text_fields.dart';
import '../../widgets/forum_widgets/saved_post_card.dart';
import '/src/ui/widgets/app_widgets/buttons.dart';
import '/src/controllers/home_controllers/search_controller.dart';
import '/src/di/service_locator.dart';

class SearchPage extends StatefulWidget {
  static const routeName = 'search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool load = false;
  SearchController controller = serviceLocator<SearchController>();

  @override
  void dispose() {
    controller.debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(controller),
    );
  }

  _buildBody(SearchController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<SearchController>(
        builder: (context, controller, _) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const AuthBackButton(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.77,
                        child: SearchWidget(
                          text: controller.query,
                          hintText: 'Search for posts using keywords',
                          onChanged: controller.searchPosts,
                        ),
                      ),
                    ],
                  ),
                  (controller.list.isEmpty)
                      ? Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              SvgPicture.asset(
                                'assets/big_search.svg',
                                width: 200,
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'No Post',
                                style: style(FontWeight.bold, 20, textColorBlack),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Enter a keyword you’re trying to find and search for a post',
                                style: style(FontWeight.w500, 16, textColorBlack),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                'Showing Results for "${controller.result}"',
                                style: style(FontWeight.w600, 18, textColorBlack),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: controller.list.length,
                                  itemBuilder: (context, index) {
                                    return savePostCard(
                                      context,
                                      post: controller.list[index],
                                      myPost: false,
                                      more: () {},
                                      like: () {},
                                      liked: true,
                                      controller: controller.controller,
                                      load: load,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
