// ignore_for_file: avoid_print

import 'dart:async';

import 'package:jojolo_mobile/src/data/api_data/api_implementation.dart/chat_implementation/chat_implementation.dart';
import 'package:jojolo_mobile/src/data/models/chat_request_model.dart';
import 'package:jojolo_mobile/src/data/models/payment_history.dart';
import 'package:jojolo_mobile/src/data/models/tag_post_models.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../models/booking_models/doctor_request.dart';
import '../models/booking_models/list_doctor.dart';
import '../models/child.dart';
import '../models/plans.dart';
import '../models/post_models.dart';
import '../models/user/caregiver.dart';
import '../models/user/doctor.dart';
import '../models/user/notification_model.dart';
import '../storage_data/storage_data.dart';

abstract class Register {
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
  );

  Future<String> registerDoctor(
    String role,
    String fullName,
    String emailAddress,
    String phoneNumber,
    String address,
    String cityOrState,
    String country,
    String yearsOfExperience,
    // File? doctorImage,
    String password,
    String confirmPassword,
  );

  Future<String> updateMedLicensce(String path);
  Future<String> updateValidId(String path);
  Future<bool> addChild(
    String name,
    DateTime dob,
    String gender,
    String genotype,
    String bloodGroup,
    String allergies,
  );
}

abstract class Login {
  Future<String> login(
    String emailAddress,
    String password,
    String role,
  );

  Future<bool> pingServer(String id, String token);
}

abstract class ForgotPass {
  Future<bool> send(String email, int type);
  Future<String> verifyCode(String code, int type);
  Future<bool> updatePassword(String email, String newPass, String confirm, int type);
}

abstract class PostFeed {
  Future<List<Post>> getPosts();
  Future<List<Post>> latestPosts();
  Future<List<Post>> popularPosts();
  Future<List<Post>> getMyPosts();
  Future<List<Post>> getSavedPosts();
  Future<List<Tag>> getTags();
  Future<bool> savePost(String postId);
  Future<bool> unSavePost(String postId);
  Future<bool> isliked(String postId);
  Future<bool> isCommentliked(String postId, String commentId);
  Future<bool> likeUnlike(String postId);
  Future<String> createPost(
    String title,
    String content,
    String? tags,
    List<String?> postImage,
    bool postAnon,
  );
  Future<Post> getPost(String postId);
  Future<bool> delPost(String postId);
  Future<bool> comment(String postId, String comments);
  Future<bool> likeUnlikeComment(String postId, String commentId);
  Future<bool> reply(String postId, String reply, String commentId);
  Future<bool> reportPost(String postId);
  Future<List<TagPost>> getTagName(String tagName);
  Future<dynamic> getTagNumber();
  Future<List<Notices>> getNotificationHistory();
  Future<void> setNotification(String id);
}

abstract class Search {
  Future<List<Post>> searchPosts(String query);
}

abstract class Accounts {
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  );
  Future<bool> updateInfo(
    String fullname,
    String emailAddress,
    String phoneNumber,
    String? bio,
    String? image,
  );
  Future<UserDoctor> getDoctor(String? id);
  Future<UserCaregiver> getCaregiver();
  Future<Notifications> getNotifications();
  Future<Ref> sub();
  Future<bool> verifyPayment(String reference);
  Future<List<Child>> getChild();
  Future<bool> setAvailability(
    String availability,
    String day,
    List<Map<String, String>> time,
    String timeId,
  );
  Future<bool> deleteAvailability(String availability);
  Future<bool> createAvailability(
    String day,
    List<Map<String, String>> time,
  );
  Future<Plans> getSubPlans();
  Future<List<Plans>> getSubs();
  Future<List<PaymentHistory>> getPaymentHistory();
}

abstract class Book {
  Future<List<Bookings>> getDoctorRequest();
  Future<List<ListDoctor>> getDoctorList();
  Future<List<ListDoctor>> getOnlineDoctorList();
  Future<bool> acceptRequest(String availabilityId, String bookingId);
  Future<bool> rejectRequest(String availabilityId, String bookingId);
  Future<bool> completeRequest(String availabilityId, String bookingId);
  Future<List<Bookings>> getUpcomingEvents();
  Future<bool> postConsultationForm(
    String caregiver,
    String presentingComplaint,
    String observations,
    String workingDiagnosis,
    String investigations,
    String prescription,
    String advice,
  );
  Future<bool> createBooking(
    String day,
    List<Map<String, String>> time,
    String doctorId,
    String availabilityId,
    String typeofService,
    String topic,
    String agenda,
  );
  Future<bool> rescheduleBooking(
    String day,
    List<Map<String, String>> time,
    String doctorId,
    String availabilityId,
    String? caregiver,
    String bookingsId,
  );
  Future<bool> vaccinationBooking(
    String childId,
    String address,
    String city,
  );
  Future<bool> cancelBooking(String bookingId);
}

abstract class Chat {
  Future<String> sendChatRequest(String doctorId, String text);
  Future<List<ChatRequest>> getChatRequests();
  Future<bool> acceptRequest(String chatId);
  Future<bool> rejectRequest(String chatId);
  Future<bool> endChat(String chatId);
  Future<List<MessageChat>> getChat(String dId);
  Future<ChatAccepted> chatExpired(String dId);
  Future<String> getChatId(String dId);
  Future<List<DoctorChat>> getDoctorChat(String chatId);
}

class Ref {
  String reference;
  String accessCode;

  Ref({required this.reference, required this.accessCode});

  factory Ref.fromJson(Map<String, dynamic> json) {
    return Ref(
      reference: json['reference'],
      accessCode: json['access_code'],
    );
  }
}

class SocketService {
  final Storage store = serviceLocator<Storage>();

  io.Socket socket = io.io('wss://backend.jojoloapp.com', {
    'transports': ['websocket'],
    'autoConnect': true,
  });

  createSocketConnection() async {
    var id = await store.getId();
    var type = await store.getUserType();
    print(socket.active);

    socket.onConnect((data) {
      print('connected');
      print(socket.id!);
      socket.emit(
        'join',
        {
          "name": "$id",
          "type": "$type",
          "socketId": socket.id!,
        },
      );
      socket.on('join', (data) {
        print(socket.id);
        print(data);
      });
    });
    print(socket.connected);
  }

  sendMessage(String message, String doctorId, String chatId) async {
    var id = await store.getId();
    var type = await store.getUserType();

    // print({
    //   'type': "Caregiver",
    //   'name': '$id',
    //   'message': message,
    //   'recipient': doctorId,
    //   'chatRequestId': chatId,
    // });

    (type == 'caregiver')
        ? socket.emit('private-message', {
            'type': "Doctors",
            'name': '$id',
            'message': message,
            'recipient': doctorId,
            'chatRequestId': chatId,
          })
        : socket.emit('private-message', {
            'type': "Caregiver",
            'name': '$id',
            'message': message,
            'recipient': doctorId,
            'chatRequestId': chatId,
          });

    socket.on('private-message', (data) => print(data));
  }
}

class Notices {
  Notices({
    required this.id,
    required this.acceptor,
    required this.transmitter,
    required this.title,
    required this.text,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? acceptor;
  final String? transmitter;
  final String? title;
  final String? text;
  final String? status;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Notices.fromJson(Map<String, dynamic> json) {
    return Notices(
      id: json["_id"],
      acceptor: json["acceptor"],
      transmitter: json["transmitter"],
      title: json["title"],
      text: json["text"],
      status: json["status"],
      isRead: json["isRead"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "acceptor": acceptor,
        "transmitter": transmitter,
        "title": title,
        "text": text,
        "status": status,
        "isRead": isRead,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
