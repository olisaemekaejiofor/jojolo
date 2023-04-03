class Plans {
  Plans({
    required this.totalAppSubscription,
    required this.appSubscription,
  });

  final int? totalAppSubscription;
  final List<AppSubscription> appSubscription;

  factory Plans.fromJson(Map<String, dynamic> json) {
    return Plans(
      totalAppSubscription: json["totalAppSubscription"],
      appSubscription: json["appSubscription"] == null
          ? []
          : List<AppSubscription>.from(
              json["appSubscription"]!.map((x) => AppSubscription.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "totalAppSubscription": totalAppSubscription,
        "appSubscription":
            List<AppSubscription>.from(appSubscription.map((x) => x.toJson())),
      };
}

class AppSubscription {
  AppSubscription({
    required this.id,
    required this.subscriptionName,
    required this.monthlyPlan,
    required this.yearlyPlan,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? subscriptionName;
  final List<LyPlan> monthlyPlan;
  final List<LyPlan> yearlyPlan;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory AppSubscription.fromJson(Map<String, dynamic> json) {
    return AppSubscription(
      id: json["_id"],
      subscriptionName: json["subscriptionName"],
      monthlyPlan: json["monthlyPlan"] == null
          ? []
          : List<LyPlan>.from(json["monthlyPlan"]!.map((x) => LyPlan.fromJson(x))),
      yearlyPlan: json["yearlyPlan"] == null
          ? []
          : List<LyPlan>.from(json["yearlyPlan"]!.map((x) => LyPlan.fromJson(x))),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subscriptionName": subscriptionName,
        "monthlyPlan": List<LyPlan>.from(monthlyPlan.map((x) => x.toJson())),
        "yearlyPlan": List<LyPlan>.from(yearlyPlan.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class LyPlan {
  LyPlan({
    required this.chat,
    required this.planAmount,
    required this.wellnessCheckup,
    required this.virtualConsultation,
    required this.endDate,
    required this.id,
    required this.startDate,
  });

  final int? chat;
  final int? planAmount;
  final int? wellnessCheckup;
  final int? virtualConsultation;
  final DateTime? endDate;
  final String? id;
  final DateTime? startDate;

  factory LyPlan.fromJson(Map<String, dynamic> json) {
    return LyPlan(
      chat: json["chat"],
      planAmount: json["planAmount"],
      wellnessCheckup: json["wellnessCheckup"],
      virtualConsultation: json["virtualConsultation"],
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
        "endDate": endDate?.toIso8601String(),
        "_id": id,
        "startDate": startDate?.toIso8601String(),
      };
}
