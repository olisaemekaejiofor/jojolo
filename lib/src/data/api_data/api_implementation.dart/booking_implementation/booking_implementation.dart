// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jojolo_mobile/src/data/models/booking_models/list_doctor.dart';

import '/src/data/api_data/api_data.dart';
import '/src/data/models/booking_models/doctor_request.dart';
import '/src/data/storage_data/storage_data.dart';
import '/src/di/service_locator.dart';
import '/src/utils/api_routes.dart';

class BookingImpl implements Book {
  final Storage store = serviceLocator<Storage>();
  @override
  Future<List<Bookings>> getDoctorRequest() async {
    String? id = await store.getId();
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.getPending + '$id');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);

      if (bodyData['data']['bookings'] == null) {
        return [];
      } else {
        List<dynamic> list = bodyData['data']['bookings'];
        var u = list.map((dynamic item) => Bookings.fromJson(item)).toList();
        return u.where((e) => e.status == 'PENDING').toList();
      }
    } else {
      return [];
    }
  }

  @override
  Future<bool> acceptRequest(String availabilityId, String bookingId) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var url = Uri.parse(AppUrl.doctor + '/accept-booking-request');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "doctorId": "$id",
      "availabilityId": availabilityId,
      "bookingsId": bookingId,
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Bookings>> getUpcomingEvents() async {
    String? id = await store.getId();
    String? token = await store.getToken();
    String? type = await store.getUserType();
    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.getUpcoming + '$id&limit=10000')
        : Uri.parse(AppUrl.getdUpcoming + '$id&limit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['bookings'];

      return list
          .map((dynamic item) => Bookings.fromJson(item))
          .toList()
          .where((e) => e.status == 'ACCEPTED' || e.typeOfService == null)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> rejectRequest(String availabilityId, String bookingId) async {
    String? token = await store.getToken();
    String? id = await store.getId();

    var url = Uri.parse(AppUrl.doctor + '/reject-booking-request');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "doctorId": "$id",
      "availabilityId": availabilityId,
      "bookingsId": bookingId,
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<ListDoctor>> getDoctorList() async {
    String? id = await store.getId();
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.caregiver + '/doctors-list?caregiverId=$id&imit=10000');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);
    //
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['doctors'];

      var l = list.map((dynamic item) => ListDoctor.fromJson(item)).toList();
      return l.where((e) => e.availabilityId.isNotEmpty).toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<ListDoctor>> getOnlineDoctorList() async {
    String? id = await store.getId();
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.caregiver + '/updated-doctors-list?caregiverId=$id');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.get(url, headers: headers);
    //
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['doctors'];

      var l = list.map((dynamic item) => ListDoctor.fromJson(item)).toList();
      return l.where((e) => e.availabilityId.isNotEmpty).toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> postConsultationForm(
    String caregiver,
    String presentingComplaint,
    String observations,
    String workingDiagnosis,
    String investigations,
    String prescription,
    String advice,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var url = Uri.parse(AppUrl.doctor + '/consultation-form');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "doctorId": '$id',
      "caregiverId": caregiver,
      "childInformationId": "620f89d71f45bafc01c4783a",
      "presentingComplaint": presentingComplaint,
      " observations": observations,
      "workingDiagnosis": workingDiagnosis,
      "investigations": investigations,
      "prescription": prescription,
      "advise": advice,
      "referrals": "Doctor Iyanu"
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> createBooking(
    String day,
    List<Map<String, String>> time,
    String doctorId,
    String availabilityId,
    String typeofService,
    String topic,
    String agenda,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var url = Uri.parse(AppUrl.caregiver + '/create-booking');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "doctorId": doctorId,
      "caregiverId": '$id',
      "availabilityId": availabilityId,
      "typeOfService": typeofService,
      "topic": topic,
      "agenda": agenda,
      "day": day,
      "time": time,
      "start_time": time[0]['startTime']
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> rescheduleBooking(
      String day,
      List<Map<String, String>> time,
      String doctorId,
      String availabilityId,
      String? caregiver,
      String bookingsId) async {
    String? token = await store.getToken();
    String? type = await store.getUserType();
    String? id = await store.getId();
    var url = type == 'caregiver'
        ? Uri.parse(AppUrl.caregiver + '/reschedule-booking')
        : Uri.parse(AppUrl.doctor + '/reschedule-booking');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "doctorId": doctorId,
      "caregiverId": caregiver ?? '$id',
      "availabilityId": availabilityId,
      "typeOfService": 'Reschedule Booking',
      "topic": 'Meeting with a Patient',
      "agenda": 'Body anatomy',
      "day": day,
      "time": time,
      "startTime": time[0]['startTime'],
      "bookingsId": bookingsId
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    String? token = await store.getToken();
    var url = Uri.parse(AppUrl.caregiver + '/bookings/$bookingId');

    var headers = {'Authorization': 'Bearer $token'};

    var res = await http.delete(url, headers: headers);

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> vaccinationBooking(String childId, String address, String city) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var url = Uri.parse(AppUrl.caregiver + '/book-vaccination');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {
      "childId": [
        {"childId": childId}
      ],
      "caregiverId": '$id',
      "address": address,
      "city": city,
      "state": "Lagos",
      "allergies": "None",
      "specialNeedsPartA": "None",
      "specialNeedsPartB": "Nill",
      "vaccineTypeId": "Nill"
    };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> completeRequest(String availabilityId, String bookingId) async {
    String? token = await store.getToken();

    var url = Uri.parse(AppUrl.doctor + '/bookings/$bookingId');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = {"status": "COMPLETED"};

    var res = await http.put(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
