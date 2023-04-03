class ChatRequest {
  ChatRequest({
    required this.id,
    required this.doctorId,
    required this.caregiverId,
    required this.hasExpired,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final RId? doctorId;
  final RId? caregiverId;
  final bool? hasExpired;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      id: json["_id"],
      doctorId: json["doctorId"] == null ? null : RId.fromJson(json["doctorId"]),
      caregiverId: json["caregiverId"] == null ? null : RId.fromJson(json["caregiverId"]),
      hasExpired: json["hasExpired"],
      status: json["status"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "doctorId": doctorId?.toJson(),
        "caregiverId": caregiverId?.toJson(),
        "hasExpired": hasExpired,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class RId {
  RId({
    required this.id,
    required this.fullName,
    required this.rolesDescription,
    required this.phoneNumber,
    required this.role,
  });

  final String? id;
  final String? fullName;
  final String? rolesDescription;
  final String? phoneNumber;
  final String? role;

  factory RId.fromJson(Map<String, dynamic> json) {
    return RId(
      id: json["_id"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      phoneNumber: json["phoneNumber"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "phoneNumber": phoneNumber,
        "role": role,
      };
}
