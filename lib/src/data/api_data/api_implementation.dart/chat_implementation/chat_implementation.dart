// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/data/models/chat_request_model.dart';
import 'package:jojolo_mobile/src/data/storage_data/storage_data.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/chat_page.dart';
import 'package:jojolo_mobile/src/utils/api_routes.dart';

class ChatImpl implements Chat {
  final Storage store = serviceLocator<Storage>();
  @override
  Future<String> sendChatRequest(String doctorId, String message) async {
    String? id = await store.getId();
    String? token = await store.getToken();

    var url = Uri.parse(AppUrl.caregiver + '/send-chat-request');

    var headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

    var body = {
      "caregiverId": "$id",
      "doctorId": doctorId,
      "status": "PENDING",
      'text': message
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      return bodyData['data']['_id'];
    } else {
      return 'Failed';
    }
  }

  @override
  Future<List<ChatRequest>> getChatRequests() async {
    String? id = await store.getId();
    String? token = await store.getToken();
    String? type = await store.getUserType();

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/chat-request/?caregiverId=$id&limit=100000')
        : Uri.parse(AppUrl.doctor + '/chat-request/?doctorId=$id&limit=100000');
    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['ChatRequests'];
      List<ChatRequest> data = list.map((e) => ChatRequest.fromJson(e)).toList();
      var listD =
          data.where((e) => e.status != 'REJECTED' && e.status != 'COMPLETED').toList();
      var notExpired = listD.where((e) {
        var diff = DateTime.now().difference(e.updatedAt!);
        return diff.inMinutes < 30;
      }).toList();
      return notExpired;
    } else {
      return [];
    }
  }

  @override
  Future<bool> acceptRequest(String chatId) async {
    String? token = await store.getToken();

    var url = Uri.parse(AppUrl.doctor + '/update-chat-request/$chatId');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {"status": "ACCEPTED"};

    var res = await http.put(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> endChat(String chatId) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var url = Uri.parse(AppUrl.doctor + '/end-chat-request');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {"doctorId": "$id", "chatRequestId": chatId};

    var res = await http.put(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> rejectRequest(String chatId) async {
    String? token = await store.getToken();

    var url = Uri.parse(AppUrl.doctor + '/update-chat-request/$chatId');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {"status": "REJECTED", "hasExpired": true};

    var res = await http.put(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<MessageChat>> getChat(String chatId) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var url = Uri.parse(AppUrl.caregiver +
        '/receive-chat?caregiverId=$id&chatRequestId=$chatId&limit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);
    var bodyData = jsonDecode(res.body);
    // print(bodyData);
    if (res.statusCode == 200) {
      List<dynamic> t = bodyData['data']['chats'];

      return t.map((e) => MessageChat.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<ChatAccepted> chatExpired(String dId) async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.caregiver + '/chat-request?limit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    var bodyData = jsonDecode(res.body);

    List<dynamic> list = bodyData['data']['ChatRequests'];
    List<ChatRequest> data = list.map((e) => ChatRequest.fromJson(e)).toList();
    var chatId = await getChatId(dId);
    if (chatId != 'no id') {
      var h = data.where((e) => e.id == chatId).toList();

      var diff = DateTime.now().difference(h[0].createdAt!);

      if (h.first.status == 'REJECTED' || diff.inMinutes > 120) {
        return ChatAccepted(expired: true, accepted: false);
      } else if (h.first.status == 'ACCEPTED' && diff.inMinutes < 120) {
        return ChatAccepted(
          accepted: true,
          expired: false,
          updatedAt: h.first.updatedAt,
        );
      } else {
        return ChatAccepted(
          accepted: false,
          expired: false,
        );
      }
    } else {
      return ChatAccepted(expired: true, accepted: false);
    }
  }

  @override
  Future<List<DoctorChat>> getDoctorChat(String chatId) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var url = Uri.parse(
        AppUrl.doctor + '/receive-chat?doctorId=$id&chatRequestId=$chatId&limit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    var bodyData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      List<dynamic> t = bodyData['data']['chats'];

      return t.map((e) => DoctorChat.fromJson(e)).toList();
    } else {
      throw Error();
    }
  }

  @override
  Future<String> getChatId(String dId) async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.caregiver + '/chat-request?limit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    var bodyData = jsonDecode(res.body);

    List<dynamic> list = bodyData['data']['ChatRequests'];
    List<ChatRequest> u = list.map((e) => ChatRequest.fromJson(e)).toList();

    var data = u.lastWhere((e) => e.doctorId!.id == dId);

    var diff = DateTime.now().difference(data.createdAt!);

    if (data.status == 'REJECTED' || diff.inMinutes > 120) {
      return 'no id';
    } else if (data.status == 'ACCEPTED' || diff.inMinutes < 120) {
      return data.id!;
    } else {
      return data.id!;
    }
  }
}

class ChatAccepted {
  bool expired;
  bool accepted;
  DateTime? updatedAt;

  ChatAccepted({required this.expired, required this.accepted, this.updatedAt});
}
