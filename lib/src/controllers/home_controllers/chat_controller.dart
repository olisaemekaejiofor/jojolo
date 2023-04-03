// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../data/models/user/doctor.dart';
import '/src/data/models/chat_request_model.dart';
import '/src/ui/screens/home_screens/private_chat/chat_page.dart';
import '../../ui/screens/home_screens/private_chat/doctor_chat_page.dart';
import '/src/ui/widgets/app_widgets/app_flush.dart';
import '/src/utils/colors.dart';
import '/src/utils/page_route.dart';
import '../../data/api_data/api_data.dart';
import '../../data/models/booking_models/list_doctor.dart';
import '../../data/models/user/caregiver.dart';
import '../../data/storage_data/storage_data.dart';
import '../../di/service_locator.dart';

class ChatController extends ChangeNotifier {
  final Storage store = serviceLocator<Storage>();
  final Accounts accounts = serviceLocator<Accounts>();
  final Book booking = serviceLocator<Book>();
  final Chat chat = serviceLocator<Chat>();
  final TextEditingController text = TextEditingController();

  ScrollController scrollController = ScrollController();
  late UserDoctor doctor;
  int timer = 0;
  String status = '';
  UserCaregiver? userCaregiver;
  List<Message?> messages = [];
  List<MessageChat> messageChat = [];
  List<DoctorChat> doctorChat = [];
  late String chats;
  List<ListDoctor> doctors = [];
  List<ListDoctor> allDoctors = [];
  List<ChatRequest> chatrequest = [];
  List<String> roles = ['All'];
  bool loading = true;
  bool load = false;
  String type = '';
  Map<String, List<ListDoctor>> map = {};
  String? image;
  String? image2;
  String? secondaryChatId;

  Future<String> sendChatRequest(String id, String message) async {
    String? uid = await store.getId();
    String? name = await store.getName();
    SocketService().socket.emit('notification-message', {
      "message": "$name is requesting to Chat with you",
      "name": "$uid",
      "recipient": id,
      "externalModelType": "Caregiver",
      "title": "Chat Activity"
    });
    var d = await chat.sendChatRequest(id, text.text);
    return d;
  }

  Future sendImage() async {
    var doc = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"],
        allowCompression: false);

    image = doc!.paths.first;
    image2 = image!;
    text.text = image!;
    notifyListeners();
  }

  void listenToSocket(String id) async {
    String? t = await store.getUserType();
    SocketService().socket.on('notification-message', (data) {
      print(data);
      var u = jsonDecode(data);
      var w = u['message'].toString().split(" ");
      if (w[4] == 'ACCEPTED') {
        status = 'ACTIVE';
        timer =
            DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch + 1000;
        notifyListeners();
      }
    });
    SocketService().socket.on('private-message', (data) {
      print(data);
      messages.add(Message(message: data, sender: false, type: 'text'));
      if (t == 'caregiver') {
        getTimer(id);

        notifyListeners();
      }
      notifyListeners();
    });
    SocketService().socket.on('attach-file', (data) {
      messages.add(Message(message: data, sender: false, type: 'network-image'));
      if (t == 'caregiver') {
        getTimer(id);
        notifyListeners();
      }
      notifyListeners();
    });
  }

  getTimer(String id) async {
    var k = await chat.chatExpired(id);
    timer = k.updatedAt!.add(const Duration(minutes: 30)).millisecondsSinceEpoch + 1000;
    notifyListeners();
    status = 'ACTIVE';
    notifyListeners();
  }

  void getChats(ChatRequest? chatrequest) async {
    if (chatrequest != null && chatrequest.status == 'ACCEPTED') {
      timer =
          chatrequest.updatedAt!.add(const Duration(minutes: 30)).millisecondsSinceEpoch +
              1000;
      status = 'ACTIVE';
      var i = await chat.getChat(chatrequest.id!);
      for (var i in i) {
        messages.add(Message(
            message: (i.fileUrl != null) ? i.fileUrl! : i.text!,
            sender: (i.type == 'Doctors') ? false : true,
            type: (i.fileUrl == null) ? 'text' : 'network-image'));
      }
      notifyListeners();
    } else if (chatrequest != null && chatrequest.status == 'PENDING') {
      status = 'PENDING';
      var i = await chat.getChat(chatrequest.id!);
      for (var i in i) {
        messages.add(Message(
            message: (i.fileUrl != null) ? i.fileUrl! : i.text!,
            sender: (i.type == 'Doctors') ? false : true,
            type: (i.fileUrl == null) ? 'text' : 'network-image'));
      }
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }

  void getUser() async {
    UserCaregiver user = await accounts.getCaregiver();
    userCaregiver = user;
    // if (user.plan.isNotEmpty) {
    //   load = false;
    //   Navigator.push(ctx, CustomPageRoute(child: ChatPage(doctor: doctor)));
    //   notifyListeners();
    // } else {
    //   load = false;
    //   Navigator.push(
    //     ctx,
    //     CustomPageRoute(
    //       child: const CheckSubscription(),
    //     ),
    //   );
    //   notifyListeners();
    // }
    notifyListeners();
  }

  void getType() async {
    String? data = await store.getUserType();

    type = data.toString();
    notifyListeners();
  }

  void reload() async {
    doctors = await booking.getOnlineDoctorList();
    notifyListeners();
  }

  void getDoctors() async {
    getUser();
    var d = await booking.getOnlineDoctorList();
    doctors = d.where((e) => e.isAvailable == true).toList();
    allDoctors = d.where((e) => e.isAvailable == true).toList();
    for (var i in doctors) {
      var l = doctors.where((e) => e.role == i.role).toList();
      map.addAll({"${i.role}": l});
    }
    seperateList(doctors);
    loading = false;
    notifyListeners();
  }

  void getChatRequests() async {
    String? id = await store.getId();
    String? type = await store.getUserType();
    if (type != 'caregiver') {
      doctor = await accounts.getDoctor(id);
    }
    chatrequest = await chat.getChatRequests();
    loading = false;
    notifyListeners();
  }

  void seperateList(List<ListDoctor> d) {
    for (var i in d) {
      roles.add(i.role.toString());
    }
  }

  void acceptRequest(String id, ChatRequest request, BuildContext ctx) async {
    String? name = await store.getName();
    String? uid = await store.getId();
    var check = await chat.acceptRequest(id);
    if (check == true) {
      SocketService().socket.emit('notification-message', {
        "message": "Dr $name has ACCEPTED your chat request",
        "name": "$uid",
        "recipient": request.caregiverId!.id!,
        "externalModelType": "Doctor",
        "title": "Chat Activity"
      });
      getChatRequests();
      Navigator.push(
        ctx,
        CustomPageRoute(
          child: DoctorChatPage(
            doctor: request,
          ),
        ),
      );
    } else {
      showFlush(
        ctx,
        message: 'Unable to accept request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void declineRequest(String id, BuildContext ctx, int index) async {
    String? name = await store.getName();
    String? uid = await store.getId();
    var check = await chat.rejectRequest(id);
    if (check == true) {
      SocketService().socket.emit('notification-message', {
        "message": "Dr $name has REJECTED your chat request",
        "name": "$uid",
        "recipient": chatrequest[index].caregiverId!.id!,
        "externalModelType": "Doctor",
        "title": "Chat Activity"
      });
      chatrequest.removeAt(index);
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to accept request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void endChat(ChatRequest req, String bId, int index, BuildContext ctx) async {
    String? name = await store.getName();
    String? uid = await store.getId();
    var check = await chat.endChat(req.id!);

    if (check == true) {
      SocketService().socket.emit('notification-message', {
        "message": "Dr $name has ENDED the chat",
        "name": "$uid",
        "recipient": req.caregiverId!.id!,
        "externalModelType": "Doctor",
        "title": "Chat Activity"
      });
      chatrequest.removeAt(index);
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to accept request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void getDoctorChat(String id, String recipient) async {
    var d = await chat.getDoctorChat(id);
    doctorChat = d;
    for (var i in doctorChat) {
      messages.add(Message(
          message: (i.fileUrl != null) ? i.fileUrl! : i.text!,
          sender: (i.type == null)
              ? false
              : (i.type == 'Caregiver')
                  ? true
                  : false,
          type: (i.fileUrl == null) ? 'text' : 'network-image'));
    }
    loading = false;
    notifyListeners();
  }

  void sendChat(ChatRequest? chatRequest, ListDoctor doctor) async {
    String? id = await store.getId();
    print(chatRequest?.id!);
    print(secondaryChatId);
    if (image != null) {
      final bytes = File(image!).readAsBytesSync();
      String img64 = base64Encode(bytes);
      SocketService().socket.emit('attach-file', {
        "name": '$id',
        "recipient": doctor.id!,
        "type": "Caregiver",
        "file": img64,
        'chatRequestId': (chatRequest != null) ? chatRequest.id! : secondaryChatId!,
      });
      image = null;
      text.clear();
      messages.add(Message(message: image2!, sender: true, type: 'file-image'));
      notifyListeners();
    } else {
      if (text.text.isNotEmpty) {
        print(status);
        if (status == '') {
          var chatId = await sendChatRequest(doctor.id!, text.text);
          secondaryChatId = chatId;
          messages.add(Message(message: text.text, sender: true, type: 'text'));
          status = 'PENDING';
          notifyListeners();
        } else if (status == 'PENDING') {
          SocketService().sendMessage(text.text, doctor.id!,
              (chatRequest != null) ? chatRequest.id! : secondaryChatId!);
          messages.add(Message(message: text.text, sender: true, type: 'text'));
          notifyListeners();
        } else if (status == 'ACCEPTED' || status == 'ACTIVE') {
          print(chatRequest?.id!);
          SocketService().sendMessage(text.text, doctor.id!,
              (chatRequest != null) ? chatRequest.id! : secondaryChatId!);
          messages.add(Message(message: text.text, sender: true, type: 'text'));
          notifyListeners();
        }
        text.clear();
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void sendDoctorChat(ChatRequest chatRequest) async {
    String? id = await store.getId();
    print(chatRequest.id);
    if (image != null) {
      final bytes = File(image!).readAsBytesSync();
      String img64 = base64Encode(bytes);
      SocketService().socket.emit('attach-file', {
        "name": '$id',
        "recipient": chatRequest.caregiverId!.id!,
        "type": "Doctors",
        "file": img64,
        'chatRequestId': chatRequest.id,
      });

      image = null;
      text.clear();
      messages.add(Message(message: image2!, sender: true, type: 'file-image'));
      notifyListeners();
    } else {
      if (text.text.isNotEmpty) {
        SocketService().socket.emit('private-message', {
          "name": '$id',
          "recipient": chatRequest.caregiverId!.id!,
          "type": "Doctors",
          "message": text.text,
          'chatRequestId': chatRequest.id,
        });
        messages.add(Message(message: text.text, sender: true, type: 'text'));
        text.clear();
        notifyListeners();
      }
    }
  }
}
