// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';

import '../../../../utils/api_routes.dart';

class ForgotImpl implements ForgotPass {
  @override
  Future<bool> send(String email, int type) async {
    var body = {"emailAddress": email.trim()};
    var headers = {'Content-Type': 'application/json'};

    var url = type == 0 ? Uri.parse(AppUrl.sendCode) : Uri.parse(AppUrl.sendDCode);
    try {
      var res = await http.post(url, headers: headers, body: jsonEncode(body));

      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } on FormatException {
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> verifyCode(String code, int type) async {
    var body = {"verificationCode": code};
    var headers = {'Content-Type': 'application/json'};
    var url = type == 0 ? Uri.parse(AppUrl.verifyCode) : Uri.parse(AppUrl.verifyDCode);
    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    try {
      if (res.statusCode == 200) {
        var bodyData = jsonDecode(res.body);
        return bodyData['data']['emailAddress'];
      } else {
        return 'failed';
      }
    } on SocketException {
      return 'No Internet. Please check your Internet Connection';
    } on FormatException {
      return 'Format Exception: Please Try again later';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<bool> updatePassword(
      String email, String newPass, String confirm, int type) async {
    var body = {
      "emailAddress": email.trim(),
      "newPassword": newPass,
      "confirmPassword": confirm
    };
    var headers = {'Content-Type': 'application/json'};

    var url =
        type == 0 ? Uri.parse(AppUrl.resetPassword) : Uri.parse(AppUrl.resetDPassword);
    try {
      var res = await http.put(url, headers: headers, body: jsonEncode(body));

      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } on FormatException {
      return false;
    } catch (e) {
      return false;
    }
  }
}
