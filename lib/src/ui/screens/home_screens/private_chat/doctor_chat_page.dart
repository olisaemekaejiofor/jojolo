import 'dart:io' as uo;

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/chat_controller.dart';
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/data/models/chat_request_model.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/text_fields.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../../utils/text_style.dart';

class DoctorChatPage extends StatefulWidget {
  final ChatRequest doctor;
  static const routeName = 'chat-page';

  const DoctorChatPage({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  final ChatController controller = serviceLocator<ChatController>();
  // List<Message> chat = [];

  @override
  void initState() {
    setState(() {
      controller.timer = widget.doctor.updatedAt!
              .add(const Duration(minutes: 30))
              .millisecondsSinceEpoch +
          1000;
    });
    SocketService().createSocketConnection();
    controller.getDoctorChat(widget.doctor.id!, widget.doctor.caregiverId!.id!);
    controller.listenToSocket(widget.doctor.id!);
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          controller.scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          )
        });
    super.initState();
  }

  @override
  void dispose() {
    SocketService().socket.off('private-message');
    SocketService().socket.off('attach-file');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<ChatController>(builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: (controller.loading == true)
                      ? Container()
                      : CountdownTimer(
                          endTime: widget.doctor.updatedAt!
                                  .add(const Duration(minutes: 30))
                                  .millisecondsSinceEpoch +
                              1000,
                          widgetBuilder: (context, time) {
                            if (time == null) {
                              return Text(
                                'Chat Expired'.toUpperCase(),
                                style: style(FontWeight.bold, 20, errorColor),
                              );
                            }
                            return Text(
                              (time.min == null)
                                  ? '0 : ${time.sec}'
                                  : '${time.min} : ${time.sec}',
                              style: style(FontWeight.bold, 20, textColorBlack),
                            );
                          },
                        ),
                ),
              ),
              lauthControl(widget.doctor.caregiverId!.fullName!),
              const SizedBox(height: 10),
              Divider(color: textColorGrey.withOpacity(0.4)),
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          controller: controller.scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          reverse: true,
                          cacheExtent: 1000,
                          itemCount: controller.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            var message = controller
                                .messages[controller.messages.length - index - 1]!
                                .message;
                            return (controller
                                        .messages[controller.messages.length - index - 1]!
                                        .sender ==
                                    true)
                                ? ChatBubble(
                                    clipper:
                                        ChatBubbleClipper5(type: BubbleType.sendBubble),
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                                    backGroundColor: tabColor,
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: size.width * 0.7),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (controller
                                                      .messages[
                                                          controller.messages.length -
                                                              index -
                                                              1]!
                                                      .type ==
                                                  'network-image')
                                              ? Image.network(message)
                                              : (controller
                                                          .messages[
                                                              controller.messages.length -
                                                                  index -
                                                                  1]!
                                                          .type ==
                                                      'file-image')
                                                  ? Image.file(uo.File(message))
                                                  : Text(
                                                      message,
                                                      style: style(FontWeight.w600, 18,
                                                          Colors.white),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ChatBubble(
                                    clipper: ChatBubbleClipper5(
                                        type: BubbleType.receiverBubble),
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                                    backGroundColor: backButtonBackground,
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: size.width * 0.7),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (controller
                                                      .messages[
                                                          controller.messages.length -
                                                              index -
                                                              1]!
                                                      .type ==
                                                  'network-image')
                                              ? Image.network(message)
                                              : (controller
                                                          .messages[
                                                              controller.messages.length -
                                                                  index -
                                                                  1]!
                                                          .type ==
                                                      'file-image')
                                                  ? Image.file(uo.File(message))
                                                  : Text(
                                                      message,
                                                      style: style(FontWeight.w600, 18,
                                                          textColorBlack),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: 85,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      height: double.infinity,
                      child: Center(
                        child: NormalTextFeild(controller: controller.text),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => controller.sendImage(),
                        child: SvgPicture.asset('assets/image.svg', height: 30)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => controller.sendDoctorChat(widget.doctor),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                        decoration: BoxDecoration(
                          color: textButtonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset('assets/fi_send.svg', height: 40),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
