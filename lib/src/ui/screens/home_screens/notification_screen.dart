import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/notification_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:provider/provider.dart';

import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

class NotificationScreen extends StatefulWidget {
  final List<Notifications> notify;
  const NotificationScreen({Key? key, required this.notify}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = serviceLocator<NotificationController>();

  @override
  void initState() {
    controller.listenToSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(controller),
    );
  }

  _buildBody(NotificationController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<NotificationController>(
        builder: (context, controller, _) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: (controller.butttonLoad == true)
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(tabColor),
                      ),
                    )
                  : (controller.notifications.isNotEmpty)
                      ? Column(
                          children: [
                            const SizedBox(height: 60),
                            lauthControl('Notifications'),
                            const SizedBox(height: 40),
                            Expanded(
                              child: SingleChildScrollView(
                                // controller: controller.controller,
                                child: Column(
                                  children: List.generate(
                                    controller.notifications.length,
                                    (index) => GestureDetector(
                                      onTap: () =>
                                          controller.selectNotice(context, index),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 0.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                (controller.notifications[index].title !=
                                                        'Chat Activity')
                                                    ? (controller.notifications[index]
                                                                .title ==
                                                            'Booking Activity')
                                                        ? 'assets/clock.svg'
                                                        : 'assets/conversation 1.svg'
                                                    : 'assets/mail.svg',
                                                color: tabColor,
                                                width: 25),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                        .notifications[index].title!,
                                                    style: style(FontWeight.w600, 16,
                                                        textColorBlack),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    controller.notifications[index].text!,
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: style(FontWeight.w500, 14,
                                                        textColorBlack),
                                                  ),
                                                  const SizedBox(height: 20)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            (controller.notifications[index].isRead ==
                                                    true)
                                                ? Container()
                                                : Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: textButtonColor,
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            const Align(
                              child: AuthBackButton(),
                              alignment: Alignment.centerLeft,
                            ),
                            const SizedBox(height: 140),
                            SvgPicture.asset(
                              'assets/notification_bell.svg',
                              width: 200,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'No New Notifications',
                              style: style(FontWeight.bold, 20, textColorBlack),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'We’ll notify you when anything comes up.',
                              style: style(FontWeight.w500, 16, textColorBlack),
                            ),
                            const Spacer(),
                          ],
                        ),
            ),
          );
        },
      ),
    );
  }
}
