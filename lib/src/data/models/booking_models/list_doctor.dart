class ListDoctor {
  ListDoctor({
    required this.consultationHistory,
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
    required this.isSavedPosts,
    required this.password,
    required this.confirmPassword,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.status,
    required this.availabilityId,
    required this.bookingsId,
    required this.bio,
    required this.availability,
    required this.medicalLicenseUrl,
    required this.profileUrl,
    required this.validIdCardUrl,
    required this.emailToken,
  });

  final List<ConsultationHistory> consultationHistory;
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

  final List<dynamic> isSavedPosts;
  final String? password;
  final String? confirmPassword;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? status;
  final List<AvailabilityId> availabilityId;
  final List<BookingsId> bookingsId;
  final String? bio;
  final List<Availability> availability;
  final String? medicalLicenseUrl;
  final String? profileUrl;
  final String? validIdCardUrl;
  final String? emailToken;

  factory ListDoctor.fromJson(Map<String, dynamic> json) {
    return ListDoctor(
      consultationHistory: json["consultationHistory"] == null
          ? []
          : List<ConsultationHistory>.from(
              json["consultationHistory"]!.map((x) => ConsultationHistory.fromJson(x))),
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
      isSavedPosts: json["is_SavedPosts"] == null
          ? []
          : List<dynamic>.from(json["is_SavedPosts"]!.map((x) => x)),
      password: json["password"],
      confirmPassword: json["confirmPassword"],
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
      bio: json["bio"],
      availability: json["availability"] == null
          ? []
          : List<Availability>.from(
              json["availability"]!.map((x) => Availability.fromJson(x))),
      medicalLicenseUrl: json["medicalLicenseURL"],
      profileUrl: json["profileURL"],
      validIdCardUrl: json["validIdCardURL"],
      emailToken: json["emailToken"],
    );
  }

  Map<String, dynamic> toJson() => {
        "consultationHistory":
            List<ConsultationHistory>.from(consultationHistory.map((x) => x.toJson())),
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
        "is_SavedPosts": List<dynamic>.from(isSavedPosts.map((x) => x)),
        "password": password,
        "confirmPassword": confirmPassword,
        "isVerified": isVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "status": status,
        "availabilityId":
            List<AvailabilityId>.from(availabilityId.map((x) => x.toJson())),
        "bookingsId": List<BookingsId>.from(bookingsId.map((x) => x.toJson())),
        "bio": bio,
        "availability": List<Availability>.from(availability.map((x) => x.toJson())),
        "medicalLicenseURL": medicalLicenseUrl,
        "profileURL": profileUrl,
        "validIdCardURL": validIdCardUrl,
        "emailToken": emailToken,
      };
}

class Availability {
  Availability({
    required this.id,
    required this.timePeriods,
    required this.timeInterval,
    required this.status,
    required this.bookingsId,
  });

  final String? id;
  final String? timePeriods;
  final String? timeInterval;
  final String? status;
  final String? bookingsId;

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json["_id"],
      timePeriods: json["timePeriods"],
      timeInterval: json["timeInterval"],
      status: json["status"],
      bookingsId: json["bookingsId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "timePeriods": timePeriods,
        "timeInterval": timeInterval,
        "status": status,
        "bookingsId": bookingsId,
      };
}

class AvailabilityId {
  AvailabilityId({
    required this.id,
    required this.day,
  });

  final String? id;
  final String? day;

  factory AvailabilityId.fromJson(Map<String, dynamic> json) {
    return AvailabilityId(
      id: json["_id"],
      day: json["day"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "day": day,
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
    required this.workingDiagnosis,
    required this.investigations,
    required this.caregiverId,
    required this.referrals,
    required this.childInformationId,
    required this.advise,
  });

  final String? id;
  final String? presentingComplaint;
  final String? observations;
  final String? workingDiagnosis;
  final dynamic investigations;
  final String? caregiverId;
  final String? referrals;
  final dynamic childInformationId;
  final String? advise;

  factory ConsultationHistory.fromJson(Map<String, dynamic> json) {
    return ConsultationHistory(
      id: json["_id"],
      presentingComplaint: json["presentingComplaint"],
      observations: json["observations"],
      workingDiagnosis: json["workingDiagnosis"],
      investigations: json["investigations"],
      caregiverId: json["caregiverId"],
      referrals: json["referrals"],
      childInformationId: json["childInformationId"],
      advise: json["advise"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "presentingComplaint": presentingComplaint,
        "observations": observations,
        "workingDiagnosis": workingDiagnosis,
        "investigations": investigations,
        "caregiverId": caregiverId,
        "referrals": referrals,
        "childInformationId": childInformationId,
        "advise": advise,
      };
}
