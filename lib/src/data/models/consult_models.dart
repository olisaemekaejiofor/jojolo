class Consult {
  String id;
  UserConsult caregiverId;
  UserConsult doctorId;
  String presentingComplaint;
  String workingDiagnosis;
  String investigations;
  String prescriptionOrAdvice;
  String refferals;
  String createdAt;

  Consult({
    required this.id,
    required this.caregiverId,
    required this.doctorId,
    required this.presentingComplaint,
    required this.workingDiagnosis,
    required this.investigations,
    required this.prescriptionOrAdvice,
    required this.refferals,
    required this.createdAt,
  });

  factory Consult.fromJson(Map<String, dynamic> json) {
    return Consult(
      id: json['_id'],
      caregiverId: UserConsult.fromJson(json['caregiverId']),
      doctorId: UserConsult.fromJson(json['doctorId']),
      presentingComplaint: json['presentingComplaint'],
      workingDiagnosis: json['workingDiagnosis'],
      investigations: json['investigations'],
      prescriptionOrAdvice: json['prescriptionOrAdvice'],
      refferals: json['refferals'],
      createdAt: json['createdAt'],
    );
  }
}

class UserConsult {
  String id;
  String fullName;

  UserConsult({
    required this.id,
    required this.fullName,
  });

  factory UserConsult.fromJson(Map<String, dynamic> json) {
    return UserConsult(
      id: json['_id'],
      fullName: json['fullName'],
    );
  }
}
