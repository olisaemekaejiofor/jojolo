import 'dart:io' as uo;

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/chat_controller.dart';
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/data/models/booking_models/list_doctor.dart';
import 'package:jojolo_mobile/src/data/models/chat_request_model.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/text_fields.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../../utils/text_style.dart';

class ChatPage extends StatefulWidget {
  final ListDoctor doctor;
  final ChatRequest? chatRequest;
  static const routeName = 'chat-page';

  const ChatPage({Key? key, required this.doctor, this.chatRequest}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController controller = serviceLocator<ChatController>();

  @override
  void initState() {
    SocketService().createSocketConnection();
    if (widget.chatRequest != null) {
      setState(() {
        controller.status = widget.chatRequest!.status!;
      });
    }
    // SocketService().createSocketConnection();
    controller.getChats(widget.chatRequest);
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
    // _timer.cancel();
    controller.scrollController.dispose();
    SocketService().socket.off('private-message');
    SocketService().socket.off('attach-file');
    SocketService().socket.off('notification-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller, size),
    );
  }

  _buildBody(ChatController controller, Size size) {
    return ChangeNotifierProvider<ChatController>(
      create: (context) => controller,
      child: Consumer<ChatController>(builder: (context, controller, _) {
        return Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: (controller.status != 'ACTIVE')
                    ? Text(
                        controller.status,
                        style: style(FontWeight.bold, 20, errorColor),
                      )
                    : CountdownTimer(
                        endTime: controller.timer,
                        widgetBuilder: (context, time) {
                          if (time == null) {
                            setState(() {
                              controller.status = 'EXPIRED';
                            });
                            return Text(
                              'Chat Expired'.toUpperCase(),
                              style: style(FontWeight.bold, 20, errorColor),
                            );
                          }
                          return Text(
                            '${time.min} : ${time.sec}',
                            style: style(FontWeight.bold, 20, textColorBlack),
                          );
                        },
                      ),
              ),
            ),
            lauthControl('Dr. ' + widget.doctor.fullName!),
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
                              .messages[controller.messages.length - index - 1]!.message;
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
                                                    .messages[controller.messages.length -
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
                                  clipper:
                                      ChatBubbleClipper5(type: BubbleType.receiverBubble),
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
                                                    .messages[controller.messages.length -
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
                    onTap: (controller.messages.isEmpty)
                        ? () {}
                        : () => controller.sendImage(),
                    child: SvgPicture.asset('assets/image.svg', height: 30),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => controller.sendChat(widget.chatRequest, widget.doctor),
                    child: Container(
                      padding: controller.loading == true
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: (controller.loading == true)
                            ? textButtonColor.withOpacity(0.5)
                            : textButtonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: (controller.loading == true)
                            ? const SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(fixedBottomColor),
                                ),
                              )
                            : SvgPicture.asset('assets/fi_send.svg', height: 40),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class Message {
  String message;
  bool sender;
  String type;

  Message({required this.message, required this.sender, required this.type});
}

class MessageChat {
  MessageChat({
    required this.id,
    required this.text,
    required this.doctorId,
    required this.caregiverId,
    required this.chatRequestId,
    required this.fileUrl,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? text;
  final String? doctorId;
  final CaregiverId? caregiverId;
  final String? chatRequestId;
  final String? type;
  final String? fileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory MessageChat.fromJson(Map<String, dynamic> json) {
    return MessageChat(
      id: json["_id"],
      text: json["text"],
      fileUrl: json['fileUrl'],
      doctorId: json["doctorId"],
      caregiverId:
          json["caregiverId"] == null ? null : CaregiverId.fromJson(json["caregiverId"]),
      chatRequestId: json["chatRequestId"],
      type: json["type"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "fileUrl": fileUrl,
        "doctorId": doctorId,
        "caregiverId": caregiverId?.toJson(),
        "chatRequestId": chatRequestId,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class CaregiverId {
  CaregiverId({
    required this.id,
    required this.fullName,
    required this.rolesDescription,
    required this.phoneNumber,
    required this.imageUrl,
  });

  final String? id;
  final String? fullName;
  final String? rolesDescription;
  final String? phoneNumber;
  final String? imageUrl;

  factory CaregiverId.fromJson(Map<String, dynamic> json) {
    return CaregiverId(
        id: json["_id"],
        fullName: json["fullName"],
        rolesDescription: json["rolesDescription"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
      };
}

class DoctorChat {
  DoctorChat({
    required this.id,
    required this.text,
    required this.fileUrl,
    required this.doctorId,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.v,
  });

  final String? id;
  final String? text;
  final String? fileUrl;
  final String? type;
  final DoctorId? doctorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory DoctorChat.fromJson(Map<String, dynamic> json) {
    return DoctorChat(
      id: json["_id"],
      text: json["text"],
      fileUrl: json['fileUrl'],
      type: json["type"],
      doctorId: json["doctorId"] == null ? null : DoctorId.fromJson(json["doctorId"]),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "fileUrl": fileUrl,
        "type": type,
        "doctorId": doctorId?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class DoctorId {
  DoctorId({
    required this.id,
    required this.phoneNumber,
  });

  final String? id;
  final String? phoneNumber;

  factory DoctorId.fromJson(Map<String, dynamic> json) {
    return DoctorId(
      id: json["_id"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phoneNumber": phoneNumber,
      };
}
