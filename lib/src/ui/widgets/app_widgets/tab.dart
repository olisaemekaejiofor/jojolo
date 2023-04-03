import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

class CustomTab extends StatefulWidget {
  final PageController pageController;
  final CustomTabBarController tabController;
  final List<String> list;

  const CustomTab(
      {Key? key,
      required this.pageController,
      required this.tabController,
      required this.list})
      : super(key: key);

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // top: 200,
          child: Column(
            children: const [
              SizedBox(height: 26.5),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 65, 0.0),
                child: Divider(color: textColorGrey),
              ),
            ],
          ),
        ),
        CustomTabBar(
          pageController: widget.pageController,
          tabBarController: widget.tabController,
          height: 45,
          itemCount: 2,
          builder: (context, index) {
            return TabBarItem(
              index: index,
              transform: ColorsTransform(
                highlightColor: tabColor,
                normalColor: textColorGrey,
                builder: (context, color) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0.0, 10, 20),
                    child: Text(
                      widget.list[index],
                      style: style(FontWeight.bold, 16, color),
                    ),
                  );
                },
              ),
            );
          },
          indicator: LinearIndicator(
            color: tabColor,
            bottom: 10,
            height: 6,
            radius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeTab extends StatefulWidget {
  final PageController pageController;
  final CustomTabBarController tabController;
  final List<String> list;

  const HomeTab(
      {Key? key,
      required this.pageController,
      required this.tabController,
      required this.list})
      : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // top: 200,
          child: Column(
            children: const [
              SizedBox(height: 26.5),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Divider(color: textColorGrey),
              ),
            ],
          ),
        ),
        Center(
          child: CustomTabBar(
            pageController: widget.pageController,
            tabBarController: widget.tabController,
            height: 45,
            itemCount: widget.list.length,
            builder: (context, index) {
              return TabBarItem(
                index: index,
                transform: ColorsTransform(
                  highlightColor: tabColor,
                  normalColor: textColorGrey,
                  builder: (context, color) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12.5, 0.0, 12.5, 20),
                      child: Text(
                        widget.list[index],
                        style: style(FontWeight.bold, 16, color),
                      ),
                    );
                  },
                ),
              );
            },
            indicator: LinearIndicator(
              color: tabColor,
              bottom: 10,
              height: 6,
              radius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubTab extends StatefulWidget {
  final PageController pageController;
  final CustomTabBarController tabController;
  final List<String> list;

  const SubTab(
      {Key? key,
      required this.pageController,
      required this.tabController,
      required this.list})
      : super(key: key);

  @override
  State<SubTab> createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // top: 200,
          child: Column(
            children: const [
              SizedBox(height: 26.5),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Divider(color: textColorGrey),
              ),
            ],
          ),
        ),
        Center(
          child: CustomTabBar(
            pageController: widget.pageController,
            tabBarController: widget.tabController,
            height: 45,
            itemCount: widget.list.length,
            builder: (context, index) {
              return TabBarItem(
                index: index,
                transform: ColorsTransform(
                  highlightColor: tabColor,
                  normalColor: textColorGrey,
                  builder: (context, color) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0.0, 10, 20),
                      child: Text(
                        widget.list[index],
                        style: style(FontWeight.bold, 16, color),
                      ),
                    );
                  },
                ),
              );
            },
            indicator: LinearIndicator(
              color: tabColor,
              bottom: 10,
              height: 6,
              radius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
