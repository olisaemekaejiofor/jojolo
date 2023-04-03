class Bookings {
  Bookings({
    required this.id,
    required this.bookSchedule,
    required this.bookWellnessCheckup,
    required this.timePeriods,
    required this.typeOfService,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.uniqueId,
    required this.hostMeetingLink,
    required this.doctorId,
    required this.caregiverId,
    required this.availability,
    required this.availabilityId,
    required this.startTime,
    required this.address,
    required this.city,
    required this.state,
    required this.allergies,
    required this.specialNeedsPartA,
    required this.specialNeedsPartB,
    required this.childInformation,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.joinMeetingLink,
  });

  final String? id;
  final String? bookSchedule;
  final String? bookWellnessCheckup;
  final String? timePeriods;
  final String? typeOfService;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final int? uniqueId;
  final String? hostMeetingLink;
  final DoctorId? doctorId;
  final CaregiverId? caregiverId;
  final bool? availability;
  final AvailabilityId? availabilityId;
  final String? startTime;
  final String? address;
  final String? city;
  final String? state;
  final String? allergies;
  final List<String> specialNeedsPartA;
  final List<String> specialNeedsPartB;
  final List<dynamic> childInformation;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? joinMeetingLink;

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      id: json["_id"],
      bookSchedule: json["bookSchedule"],
      bookWellnessCheckup: json["bookWellnessCheckup"],
      timePeriods: json["timePeriods"],
      typeOfService: json["typeOfService"],
      startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
      endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      status: json["status"],
      uniqueId: json["uniqueId"],
      hostMeetingLink: json["hostMeetingLink"],
      doctorId: json["doctorId"] == null ? null : DoctorId.fromJson(json["doctorId"]),
      caregiverId:
          json["caregiverId"] == null ? null : CaregiverId.fromJson(json["caregiverId"]),
      availability: json["availability"],
      availabilityId: json["availabilityId"] == null
          ? null
          : AvailabilityId.fromJson(json["availabilityId"]),
      startTime: json["start_time"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      allergies: json["allergies"],
      specialNeedsPartA: json["specialNeedsPartA"] == null
          ? []
          : List<String>.from(json["specialNeedsPartA"]!.map((x) => x)),
      specialNeedsPartB: json["specialNeedsPartB"] == null
          ? []
          : List<String>.from(json["specialNeedsPartB"]!.map((x) => x)),
      childInformation: json["childInformation"] == null
          ? []
          : List<dynamic>.from(json["childInformation"]!.map((x) => x)),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      joinMeetingLink: json["joinMeetingLink"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bookSchedule": bookSchedule,
        "bookWellnessCheckup": bookWellnessCheckup,
        "timePeriods": timePeriods,
        "typeOfService": typeOfService,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "status": status,
        "uniqueId": uniqueId,
        "hostMeetingLink": hostMeetingLink,
        "doctorId": doctorId?.toJson(),
        "caregiverId": caregiverId?.toJson(),
        "availability": availability,
        "availabilityId": availabilityId?.toJson(),
        "start_time": startTime,
        "address": address,
        "city": city,
        "state": state,
        "allergies": allergies,
        "specialNeedsPartA": List<String>.from(specialNeedsPartA.map((x) => x)),
        "specialNeedsPartB": List<String>.from(specialNeedsPartB.map((x) => x)),
        "childInformation": List<dynamic>.from(childInformation.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "joinMeetingLink": joinMeetingLink,
      };
}

class AvailabilityId {
  AvailabilityId({
    required this.id,
    // required this.availability,
  });

  final String? id;
  // final List<Availability> availability;

  factory AvailabilityId.fromJson(Map<String, dynamic> json) {
    return AvailabilityId(
      id: json["_id"],
      // availability: json["availability"] == null
      //     ? []
      //     : List<Availability>.from(
      //         json["availability"]!.map((x) => Availability.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        // "availability": List<Availability>.from(availability.map((x) => x.toJson())),
      };
}

// class Availability {
//   Availability({
//     required this.time,
//   });

//   final List<Time> time;

//   factory Availability.fromJson(Map<String, dynamic> json) {
//     return Availability(
//       time: json["time"] == null
//           ? []
//           : List<Time>.from(json["time"]!.map((x) => Time.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "time": List<Time>.from(time.map((x) => x.toJson())),
//       };
// }

// class Time {
//   Time({
//     required this.startTime,
//     required this.endTime,
//     required this.id,
//   });

//   final DateTime? startTime;
//   final DateTime? endTime;
//   final String? id;

//   factory Time.fromJson(Map<String, dynamic> json) {
//     return Time(
//       startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
//       endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
//       id: json["_id"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "startTime": startTime?.toIso8601String(),
//         "endTime": endTime?.toIso8601String(),
//         "_id": id,
//       };
// }

class CaregiverId {
  CaregiverId({
    required this.id,
    required this.fullName,
    required this.rolesDescription,
    required this.imageUrl,
  });

  final String? id;
  final String? fullName;
  final String? rolesDescription;
  final String? imageUrl;

  factory CaregiverId.fromJson(Map<String, dynamic> json) {
    return CaregiverId(
      id: json["_id"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "imageUrl": imageUrl,
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
