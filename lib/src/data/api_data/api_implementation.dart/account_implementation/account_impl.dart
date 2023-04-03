// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jojolo_mobile/src/data/models/child.dart';
import 'package:jojolo_mobile/src/data/models/payment_history.dart';
import 'package:jojolo_mobile/src/data/models/plans.dart';
import 'package:jojolo_mobile/src/data/models/user/notification_model.dart';

import '/src/data/models/user/doctor.dart';
import '/src/data/models/user/caregiver.dart';
import '/src/data/storage_data/storage_data.dart';
import '/src/di/service_locator.dart';
import '../../../../utils/api_routes.dart';
import '../../api_data.dart';

class AccountImpl implements Accounts {
  final Storage store = serviceLocator<Storage>();
  @override
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? type = await store.getUserType();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/update-password/$id')
        : Uri.parse(AppUrl.doctor + '/doctor-profile-updatepassword/$id');

    var body = (type == 'caregiver')
        ? {
            "oldPassword": oldPassword,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword,
          }
        : {
            "oldPassword": oldPassword,
            "newPassword": newPassword,
            "confirmNewPassword": confirmPassword,
          };

    var res = await http.put(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<UserCaregiver> getCaregiver() async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var url = Uri.parse(AppUrl.caregiver + '/id?id=$id');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);
    var bodyData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var user = bodyData['data']['caregivers'][0];
      print(user);
      UserCaregiver caregiver = UserCaregiver.fromJson(user);
      return caregiver;
    } else {
      throw Error();
    }
  }

  @override
  Future<UserDoctor> getDoctor(String? id) async {
    String? token = await store.getToken();
    String? uid = await store.getId();

    var url = (id != null)
        ? Uri.parse(AppUrl.doctor + '/id?id=$id')
        : Uri.parse(AppUrl.doctor + '/id?id=$uid');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);
    var bodyData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var user = bodyData['data']['doctors'][0];
      UserDoctor doctor = UserDoctor.fromJson(user);
      return doctor;
    } else {
      throw Error();
    }
  }

  @override
  Future<Notifications> getNotifications() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? type = await store.getUserType();

    var headers = {'Authorization': 'Bearer $token'};

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/notification-setting?caregiverId=$id')
        : Uri.parse(AppUrl.doctor + '/notification-setting?doctorId=$id');

    var res = await http.get(url, headers: headers);
    var bodyData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      var notifications = bodyData['data']['notificationSetting'][0];
      Notifications notify = Notifications.fromJson(notifications);
      return notify;
    } else {
      return Notifications(
        pushNotification: false,
        emailNotification: false,
        smsNotification: false,
      );
    }
  }

  @override
  Future<bool> updateInfo(
    String fullname,
    String emailAddress,
    String phoneNumber,
    String? bio,
    String? image,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? type = await store.getUserType();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/profile/$id')
        : Uri.parse(AppUrl.doctor + '/profile/$id');

    Map<String, String> body = (type == 'cargeiver')
        ? {
            "fullName": fullname,
            "emailAddress": emailAddress,
            "phoneNumber": phoneNumber,
          }
        : {
            "fullName": fullname,
            "emailAddress": emailAddress,
            "phoneNumber": phoneNumber,
            "bio": '$bio',
          };

    var req = http.MultipartRequest('PUT', url);
    req.fields.addAll(body);

    if (image != null) {
      (type == 'caregiver')
          ? req.files.add(await http.MultipartFile.fromPath('profileImage', image))
          : req.files.add(await http.MultipartFile.fromPath('image', image));
    }
    req.headers.addAll(headers);
    var res = await req.send();

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Ref> sub() async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(AppUrl.caregiver + '/subscribe-plan');

    var body = {
      "caregiverId": '$id',
      "appSubscriptionId": "6241c5c30b8af97571fbf6c3",
      "plan": "Basic",
      "timeInterval": "monthlyPlan"
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      var ref = bodyData['data']['data'];
      Ref subRef = Ref.fromJson(ref);
      return subRef;
    } else {
      throw Error();
    }
  }

  @override
  Future<bool> verifyPayment(String reference) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(AppUrl.baseUrl + '/payment/verify-payment');

    var body = {"userId": "$id", "reference": reference};

    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Child>> getChild() async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(AppUrl.caregiver + '/childs?caregiverId=$id');

    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['childInformation'];
      return list.map((e) => Child.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> createAvailability(
    String day,
    List<Map<String, String>> time,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(AppUrl.doctor + '/create-availability');
    var body = {
      "availability": [
        {
          "day": day,
          "time": time,
          "doctorId": "$id",
        }
      ],
    };
    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> deleteAvailability(String availability) async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.doctor + '/$availability');
    var headers = {'Authorization': 'Bearer $token'};
    var res = await http.delete(url, headers: headers);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> setAvailability(
    String availability,
    String day,
    List<Map<String, String>> time,
    String timeId,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var url = Uri.parse(AppUrl.doctor + '/$availability/availability');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "availabilityId": availability,
      "doctorId": "$id",
      "isActive": true,
      "time": time,
      "timeId": timeId,
    };

    var res = await http.put(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Plans> getSubPlans() async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.baseUrl + '/caregiver/subscription');
    var headers = {'Authorization': 'Bearer $token'};
    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      Plans plansM = Plans.fromJson(bodyData['data']);
      return plansM;
    } else {
      throw Error();
    }
  }

  @override
  Future<List<Plans>> getSubs() async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.baseUrl + '/caregiver/subscription');
    var headers = {'Authorization': 'Bearer $token'};
    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      print(bodyData);
      List<dynamic> plans = bodyData['data']['appSubscription'];

      return plans.map((e) => Plans.fromJson(e)).toList();
    } else {
      throw Error();
    }
  }

  @override
  Future<List<PaymentHistory>> getPaymentHistory() async {
    String? id = await store.getId();
    String? token = await store.getToken();

    var url = Uri.parse(AppUrl.paymentHistory + '$id&sort=desc');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    var bodyData = jsonDecode(res.body);
    print(bodyData);
    List<dynamic> list = bodyData['data']['paymentNotifications'];
    return list.map((e) => PaymentHistory.fromJson(e)).toList();
  }
}
