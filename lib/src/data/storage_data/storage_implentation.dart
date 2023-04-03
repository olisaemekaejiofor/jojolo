// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

import '/src/data/models/user_models.dart';
import '/src/data/storage_data/storage_data.dart';

class Store implements Storage {
  @override
  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> setAuthentication(AuthUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.userData.token);
    prefs.setString('name', user.dataInch.fullName);
    prefs.setString('userType', user.userType);

    if (user.userType == 'doctor') {
      prefs.setString('doctorId', user.userData.doctorId!);
      prefs.setString('role', user.dataInch.role!);
    }

    if (user.userType == 'caregiver') {
      prefs.setString('caregiverId', user.userData.caregiverId!);
      prefs.setString('role', user.dataInch.roleDescription!);
    }
    return true;
  }

  @override
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  @override
  Future<String?> getId() async {
    String? id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userType = prefs.getString('userType');
    if (userType == 'doctor') {
      id = prefs.getString('doctorId');
    }

    if (userType == 'caregiver') {
      id = prefs.getString('caregiverId');
    }

    return id;
  }

  @override
  void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('doctorId');
    prefs.remove('caregiverId');
    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('role');
    prefs.remove('userType');
  }

  @override
  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userType = prefs.getString('userType');
    return userType;
  }

  @override
  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userType = prefs.getString('role');
    return userType;
  }

  @override
  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userType = prefs.getString('name');
    return userType;
  }
}
