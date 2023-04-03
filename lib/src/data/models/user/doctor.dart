class UserDoctor {
  UserDoctor({
    required this.wallet,
    required this.isAvailable,
    required this.id,
    required this.fullName,
    required this.emailAddress,
    required this.role,
    required this.phoneNumber,
    required this.yearsOfExperience,
    required this.imageUrl,
    required this.address,
    required this.country,
    required this.cityOrState,
    required this.posts,
    required this.isSavedPosts,
    required this.password,
    required this.confirmPassword,
    required this.consultationHistory,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.status,
    required this.availabilityId,
    required this.bookingsId,
    required this.doctorImage,
    required this.bio,
    required this.validIdCardUrl,
    required this.medicalLicenseURL,
  });
  final int wallet;
  final bool? isAvailable;
  final String? id;
  final String? fullName;
  final String? emailAddress;
  final String? role;
  final String? phoneNumber;
  final int? yearsOfExperience;
  final String? imageUrl;
  final String? address;
  final String? country;
  final String? cityOrState;
  final List<DoctorPost> posts;
  final List<dynamic> isSavedPosts;
  final String? password;
  final String? confirmPassword;
  final List<ConsultationHistory> consultationHistory;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? status;
  final List<AvailabilityId> availabilityId;
  final List<BookingsId> bookingsId;
  final String? doctorImage;
  final String? bio;
  final String? validIdCardUrl;
  final String? medicalLicenseURL;

  factory UserDoctor.fromJson(Map<String, dynamic> json) {
    return UserDoctor(
      wallet: json["wallet"],
      isAvailable: json["isAvailable"],
      id: json["_id"],
      fullName: json["fullName"],
      emailAddress: json["emailAddress"],
      role: json["role"],
      phoneNumber: json["phoneNumber"],
      yearsOfExperience: json["yearsOfExperience"],
      imageUrl: json["imageURL"],
      address: json["address"],
      country: json["country"],
      cityOrState: json["cityOrState"],
      posts: json["posts"] == null
          ? []
          : List<DoctorPost>.from(json["posts"]!.map((x) => DoctorPost.fromJson(x))),
      isSavedPosts: json["is_SavedPosts"] == null
          ? []
          : List<dynamic>.from(json["is_SavedPosts"]!.map((x) => x)),
      password: json["password"],
      confirmPassword: json["confirmPassword"],
      consultationHistory: json["consultationHistory"] == null
          ? []
          : List<ConsultationHistory>.from(
              json["consultationHistory"]!.map((x) => ConsultationHistory.fromJson(x))),
      isVerified: json["isVerified"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      status: json["status"],
      availabilityId: json["availabilityId"] == null
          ? []
          : List<AvailabilityId>.from(
              json["availabilityId"]!.map((x) => AvailabilityId.fromJson(x))),
      bookingsId: json["bookingsId"] == null
          ? []
          : List<BookingsId>.from(json["bookingsId"]!.map((x) => BookingsId.fromJson(x))),
      doctorImage: json["doctorImage"],
      bio: json["bio"],
      validIdCardUrl: json["validIdCardURL"],
      medicalLicenseURL: json["medicalLicenseURL"],
    );
  }

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "isAvailable": isAvailable,
        "_id": id,
        "fullName": fullName,
        "emailAddress": emailAddress,
        "role": role,
        "phoneNumber": phoneNumber,
        "yearsOfExperience": yearsOfExperience,
        "imageURL": imageUrl,
        "address": address,
        "country": country,
        "cityOrState": cityOrState,
        "posts": List<DoctorPost>.from(posts.map((x) => x.toJson())),
        "is_SavedPosts": List<dynamic>.from(isSavedPosts.map((x) => x)),
        "password": password,
        "confirmPassword": confirmPassword,
        "consultationHistory":
            List<ConsultationHistory>.from(consultationHistory.map((x) => x.toJson())),
        "isVerified": isVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "status": status,
        "availabilityId":
            List<AvailabilityId>.from(availabilityId.map((x) => x.toJson())),
        "bookingsId": List<BookingsId>.from(bookingsId.map((x) => x.toJson())),
        "doctorImage": doctorImage,
        "bio": bio,
        "validIdCardURL": validIdCardUrl,
        "medicalLicenseURL": medicalLicenseURL,
      };
}

class AvailabilityId {
  AvailabilityId({
    required this.id,
    required this.day,
  });

  final Id? id;
  final String? day;

  factory AvailabilityId.fromJson(Map<String, dynamic> json) {
    return AvailabilityId(
      id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
      day: json["day"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "day": day,
      };
}

class Id {
  Id({
    required this.id,
    required this.availability,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final List<Availability> availability;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      id: json["_id"],
      availability: json["availability"] == null
          ? []
          : List<Availability>.from(
              json["availability"]!.map((x) => Availability.fromJson(x))),
      isActive: json["isActive"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "availability": List<Availability>.from(availability.map((x) => x.toJson())),
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Availability {
  Availability({
    required this.day,
    required this.time,
    required this.doctorId,
    required this.id,
  });

  final String? day;
  final List<Time> time;
  final String? doctorId;
  final String? id;

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      day: json["day"],
      time: json["time"] == null
          ? []
          : List<Time>.from(json["time"]!.map((x) => Time.fromJson(x))),
      doctorId: json["doctorId"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": List<Time>.from(time.map((x) => x.toJson())),
        "doctorId": doctorId,
        "_id": id,
      };
}

class Time {
  Time({
    required this.startTime,
    required this.endTime,
    required this.id,
  });

  final DateTime? startTime;
  final DateTime? endTime;
  final String? id;

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
      endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "_id": id,
      };
}

class BookingsId {
  BookingsId({
    required this.id,
    required this.day,
    required this.caregiverId,
    required this.status,
  });

  final String? id;
  final String? day;
  final String? caregiverId;
  final String? status;

  factory BookingsId.fromJson(Map<String, dynamic> json) {
    return BookingsId(
      id: json["_id"],
      day: json["day"],
      caregiverId: json["caregiverId"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "day": day,
        "caregiverId": caregiverId,
        "status": status,
      };
}

class ConsultationHistory {
  ConsultationHistory({
    required this.id,
    required this.presentingComplaint,
    required this.observations,
    required this.childInformationId,
    required this.advise,
    required this.workingDiagnosis,
    required this.investigations,
    required this.caregiverId,
    required this.referrals,
  });

  final String? id;
  final String? presentingComplaint;
  final String? observations;
  final dynamic childInformationId;
  final String? advise;
  final String? workingDiagnosis;
  final dynamic investigations;
  final String? caregiverId;
  final String? referrals;

  factory ConsultationHistory.fromJson(Map<String, dynamic> json) {
    return ConsultationHistory(
      id: json["_id"],
      presentingComplaint: json["presentingComplaint"],
      observations: json["observations"],
      childInformationId: json["childInformationId"],
      advise: json["advise"],
      workingDiagnosis: json["workingDiagnosis"],
      investigations: json["investigations"],
      caregiverId: json["caregiverId"],
      referrals: json["referrals"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "presentingComplaint": presentingComplaint,
        "observations": observations,
        "childInformationId": childInformationId,
        "advise": advise,
        "workingDiagnosis": workingDiagnosis,
        "investigations": investigations,
        "caregiverId": caregiverId,
        "referrals": referrals,
      };
}

class DoctorPost {
  DoctorPost({
    required this.id,
    required this.likes,
    required this.image,
    required this.comments,
    required this.shares,
  });

  final String? id;
  final List<Like> likes;
  final List<String> image;
  final List<dynamic> comments;
  final List<dynamic> shares;

  factory DoctorPost.fromJson(Map<String, dynamic> json) {
    return DoctorPost(
      id: json["_id"],
      likes: json["likes"] == null
          ? []
          : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
      comments: json["comments"] == null
          ? []
          : List<dynamic>.from(json["comments"]!.map((x) => x)),
      shares:
          json["shares"] == null ? [] : List<dynamic>.from(json["shares"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "image": List<String>.from(image.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "shares": List<dynamic>.from(shares.map((x) => x)),
      };
}

class Like {
  Like({
    required this.id,
  });

  final String? id;

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}
