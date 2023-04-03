// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '/src/data/models/user_models.dart';
import '/src/data/storage_data/storage_data.dart';
import '/src/di/service_locator.dart';
import '/src/data/api_data/api_data.dart';
import '/src/utils/api_routes.dart';

class LoginImpl implements Login {
  Storage store = serviceLocator<Storage>();
  @override
  Future<String> login(String emailAddress, String password, String role) async {
    var url =
        (role == 'd') ? Uri.parse(AppUrl.doctorLogin) : Uri.parse(AppUrl.caregiverLogin);

    var data = {
      'emailAddress': emailAddress.trim(),
      'password': password,
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    var res = await http.post(url, headers: headers, body: jsonEncode(data));

    try {
      var bodyData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var body = bodyData['data'];
        AuthUser user = AuthUser.fromJson(body);
        bool storeData = await store.setAuthentication(user);

        if (storeData == true) {
          if (role == 'd') {
            bool check = await pingServer(user.dataInch.id, user.userData.token);
            if (check == true) {
              return 'Login';
            } else {
              return 'Failed to ping server';
            }
          } else {
            return 'Login';
          }
        } else {
          return 'Failed to login. Please try again';
        }
      } else {
        return bodyData['message'];
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
  Future<bool> pingServer(String id, String token) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(AppUrl.doctor + '/keep-session-alive/$id');

    var body = jsonEncode({
      "lastActivity":
          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59)
              .toUtc()
              .toIso8601String(),
    });

    var res = await http.put(url, headers: headers, body: body);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
