class UserCaregiver {
  UserCaregiver({
    required this.id,
    required this.fullName,
    required this.emailAddress,
    required this.rolesDescription,
    required this.phoneNumber,
    required this.address,
    required this.country,
    required this.cityOrState,
    required this.imageUrl,
    required this.posts,
    required this.password,
    required this.confirmPassword,
    required this.isSavedPosts,
    required this.addChild,
    required this.emailToken,
    required this.isVerified,
    required this.status,
    required this.childInformationId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.plan,
    required this.consultationHistory,
    required this.verificationCode,
  });

  final String? id;
  final String? fullName;
  final String? emailAddress;
  final String? rolesDescription;
  final String? phoneNumber;
  final String? address;
  final String? country;
  final String? cityOrState;
  final String? imageUrl;
  final List<CaregiverPost> posts;
  final String? password;
  final String? confirmPassword;
  final List<dynamic> isSavedPosts;
  final List<dynamic> addChild;
  final String? emailToken;
  final bool? isVerified;
  final String? status;
  final List<dynamic> childInformationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<Plan> plan;
  final List<ConsultHistory> consultationHistory;
  final String? verificationCode;

  factory UserCaregiver.fromJson(Map<String, dynamic> json) {
    return UserCaregiver(
      id: json["_id"],
      fullName: json["fullName"],
      emailAddress: json["emailAddress"],
      rolesDescription: json["rolesDescription"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      country: json["country"],
      cityOrState: json["cityOrState"],
      imageUrl: json["imageUrl"],
      posts: json["posts"] == null
          ? []
          : List<CaregiverPost>.from(
              json["posts"]!.map((x) => CaregiverPost.fromJson(x))),
      password: json["password"],
      confirmPassword: json["confirmPassword"],
      isSavedPosts: json["is_SavedPosts"] == null
          ? []
          : List<dynamic>.from(json["is_SavedPosts"]!.map((x) => x)),
      addChild: json["addChild"] == null
          ? []
          : List<dynamic>.from(json["addChild"]!.map((x) => x)),
      emailToken: json["emailToken"],
      isVerified: json["isVerified"],
      status: json["status"],
      childInformationId: json["childInformationId"] == null
          ? []
          : List<dynamic>.from(json["childInformationId"]!.map((x) => x)),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      plan: json["plan"] == null
          ? []
          : List<Plan>.from(json["plan"]!.map((x) => Plan.fromJson(x))),
      consultationHistory: json["consultationHistory"] == null
          ? []
          : List<ConsultHistory>.from(
              json["consultationHistory"]!.map((x) => ConsultHistory.fromJson(x))),
      verificationCode: json["verificationCode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "emailAddress": emailAddress,
        "rolesDescription": rolesDescription,
        "phoneNumber": phoneNumber,
        "address": address,
        "country": country,
        "cityOrState": cityOrState,
        "imageUrl": imageUrl,
        "posts": List<CaregiverPost>.from(posts.map((x) => x.toJson())),
        "password": password,
        "confirmPassword": confirmPassword,
        "is_SavedPosts": List<dynamic>.from(isSavedPosts.map((x) => x)),
        "addChild": List<dynamic>.from(addChild.map((x) => x)),
        "emailToken": emailToken,
        "isVerified": isVerified,
        "status": status,
        "childInformationId": List<dynamic>.from(childInformationId.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "plan": List<Plan>.from(plan.map((x) => x.toJson())),
        "consultationHistory":
            List<ConsultHistory>.from(consultationHistory.map((x) => x.toJson())),
        "verificationCode": verificationCode,
      };
}

class ConsultHistory {
  ConsultHistory({
    required this.id,
    required this.presentingComplaint,
    required this.observations,
    required this.childInformationId,
    required this.advise,
    required this.workingDiagnosis,
    required this.investigations,
    required this.doctorId,
    required this.referrals,
  });

  final String? id;
  final String? presentingComplaint;
  final String? observations;
  final dynamic childInformationId;
  final String? advise;
  final String? workingDiagnosis;
  final dynamic investigations;
  final DoctorId? doctorId;
  final String? referrals;

  factory ConsultHistory.fromJson(Map<String, dynamic> json) {
    return ConsultHistory(
      id: json["_id"],
      presentingComplaint: json["presentingComplaint"],
      observations: json["observations"],
      childInformationId: json["childInformationId"],
      advise: json["advise"],
      workingDiagnosis: json["workingDiagnosis"],
      investigations: json["investigations"],
      doctorId: json["doctorId"] == null ? null : DoctorId.fromJson(json["doctorId"]),
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
        "doctorId": doctorId?.toJson(),
        "referrals": referrals,
      };
}

class DoctorId {
  DoctorId({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final String? id;
  final String? fullName;
  final String? role;

  factory DoctorId.fromJson(Map<String, dynamic> json) {
    return DoctorId(
      id: json["_id"],
      fullName: json["fullName"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "role": role,
      };
}

class Plan {
  Plan({
    required this.value,
    required this.isSubscribed,
    required this.planDurationId,
    required this.subscriptionName,
  });

  final Value? value;
  final bool? isSubscribed;
  final String? planDurationId;
  final String? subscriptionName;

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      value: json["value"] == null ? null : Value.fromJson(json["value"]),
      isSubscribed: json["isSubscribed"],
      planDurationId: json["planDurationId"],
      subscriptionName: json["subscriptionName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value?.toJson(),
        "isSubscribed": isSubscribed,
        "planDurationId": planDurationId,
        "subscriptionName": subscriptionName,
      };
}

class Value {
  Value({
    required this.chat,
    required this.planAmount,
    required this.wellnessCheckup,
    required this.virtualConsultation,
    required this.vaccinationService,
    required this.endDate,
    required this.id,
    required this.startDate,
  });

  final int? chat;
  final int? planAmount;
  final int? wellnessCheckup;
  final int? virtualConsultation;
  final int? vaccinationService;
  final DateTime? endDate;
  final String? id;
  final DateTime? startDate;

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      chat: json["chat"],
      planAmount: json["planAmount"],
      wellnessCheckup: json["wellnessCheckup"],
      virtualConsultation: json["virtualConsultation"],
      vaccinationService: json["vaccinationService"],
      endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      id: json["_id"],
      startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "chat": chat,
        "planAmount": planAmount,
        "wellnessCheckup": wellnessCheckup,
        "virtualConsultation": virtualConsultation,
        "vaccinationService": vaccinationService,
        "endDate": endDate?.toIso8601String(),
        "_id": id,
        "startDate": startDate?.toIso8601String(),
      };
}

class CaregiverPost {
  CaregiverPost({
    required this.id,
    required this.likes,
    required this.image,
    required this.comments,
    required this.shares,
  });

  final String? id;
  final List<dynamic> likes;
  final List<String> image;
  final List<dynamic> comments;
  final List<dynamic> shares;

  factory CaregiverPost.fromJson(Map<String, dynamic> json) {
    return CaregiverPost(
      id: json["_id"],
      likes:
          json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
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
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "image": List<String>.from(image.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "shares": List<dynamic>.from(shares.map((x) => x)),
      };
}
