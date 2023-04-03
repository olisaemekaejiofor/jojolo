// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '/src/data/storage_data/storage_data.dart';
import '/src/data/api_data/api_data.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/api_routes.dart';

class RegisterImpl implements Register {
  final Login loginClient = serviceLocator<Login>();
  final Storage store = serviceLocator<Storage>();
  @override
  Future<String> registerCaregiver(
    String rolesDescription,
    String fullName,
    String emailAddress,
    String phoneNumber,
    String address,
    String cityOrState,
    String country,
    String password,
    String confirmPassword,
  ) async {
    var url = Uri.parse(AppUrl.caregiverRegister);
    var body = {
      "rolesDescription": rolesDescription.trim(),
      "fullName": fullName.trim(),
      "emailAddress": emailAddress.trim(),
      "phoneNumber": phoneNumber.trim(),
      "address": address.trim(),
      "cityOrState": cityOrState.trim(),
      "country": country.trim(),
      "password": password.trim(),
      "confirmPassword": confirmPassword.trim(),
    };

    var headers = {'Content-Type': 'application/json'};

    try {
      var res = await http.post(url, headers: headers, body: jsonEncode(body));
      var bodyData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return 'done';
      } else {
        print(bodyData);
        return 'error';
        // return bodyData['errors'][0]['msg'];
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
  Future<String> registerDoctor(
    String role,
    String fullName,
    String emailAddress,
    String phoneNumber,
    String address,
    String cityOrState,
    String country,
    String yearsOfExperience,
    String password,
    String confirmPassword,
  ) async {
    var url = Uri.parse(AppUrl.doctorRegister);
    var body = {
      "role": role,
      "fullName": fullName.trim(),
      "emailAddress": emailAddress.trim(),
      "phoneNumber": phoneNumber.trim(),
      "address": address.trim(),
      "yearsOfExperience": yearsOfExperience.trim(),
      "cityOrState": cityOrState.trim(),
      "country": country.trim(),
      "password": password.trim(),
      "confirmPassword": confirmPassword.trim(),
    };
    var headers = {'Content-Type': 'application/json'};

    try {
      var res = await http.post(url, headers: headers, body: jsonEncode(body));
      var bodyData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return 'done';
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
  Future<String> updateMedLicensce(String path) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(AppUrl.updateLicense + '$id');

    var req = http.MultipartRequest('PUT', url)
      ..files.add(await http.MultipartFile.fromPath('profileImage', path))
      ..headers.addAll(headers);
    var res = await req.send();

    if (res.statusCode == 200) {
      return 'done';
    } else {
      return 'Failed to Upload document';
    }
  }

  @override
  Future<String> updateValidId(String path) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(AppUrl.updateId + '$id');

    try {
      var req = http.MultipartRequest('PUT', url)
        ..files.add(await http.MultipartFile.fromPath('cardImage', path))
        ..headers.addAll(headers);
      var res = await req.send();

      if (res.statusCode == 200) {
        return 'done';
      } else {
        return 'Failed to Upload document';
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
  Future<bool> addChild(
    String name,
    DateTime dob,
    String gender,
    String genotype,
    String bloodGroup,
    String allergies,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var url = Uri.parse(AppUrl.caregiver + '/add-child');

    var body = jsonEncode({
      "childName": name,
      "dateOfBirth": dob.toUtc().toIso8601String(),
      "gender": gender,
      "address": "No 10 omolupe Steet Ilesa",
      "vaccinationPlace": "Mofoluwaso Creche Cappa",
      "caregiverId": "$id",
      "vaccinationType": "Anti-Covid",
      "bloodGroup": genotype,
      "genotype": bloodGroup,
      "allergies": allergies,
      "specialNeeds": "None",
      "medicalConditions": "None"
    });

    try {
      var res = await http.post(url, headers: headers, body: body);

      if (res.statusCode == 200) {
        return true;
      } else {
        print(res.body);
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
