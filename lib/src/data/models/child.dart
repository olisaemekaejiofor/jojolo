class Child {
  Child({
    required this.id,
    required this.childName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.vaccinationPlace,
    required this.caregiverId,
    required this.vaccinationType,
    required this.bloodGroup,
    required this.genotype,
    required this.allergies,
    required this.specialNeeds,
    required this.medicalConditions,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? childName;
  final dynamic dateOfBirth;
  final String? gender;
  final String? address;
  final String? vaccinationPlace;
  final String? caregiverId;
  final String? vaccinationType;
  final String? bloodGroup;
  final String? genotype;
  final String? allergies;
  final String? specialNeeds;
  final String? medicalConditions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json["_id"],
      childName: json["childName"],
      dateOfBirth: json["dateOfBirth"],
      gender: json["gender"],
      address: json["address"],
      vaccinationPlace: json["vaccinationPlace"],
      caregiverId: json["caregiverId"],
      vaccinationType: json["vaccinationType"],
      bloodGroup: json["bloodGroup"],
      genotype: json["genotype"],
      allergies: json["allergies"],
      specialNeeds: json["specialNeeds"],
      medicalConditions: json["medicalConditions"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "childName": childName,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "address": address,
        "vaccinationPlace": vaccinationPlace,
        "caregiverId": caregiverId,
        "vaccinationType": vaccinationType,
        "bloodGroup": bloodGroup,
        "genotype": genotype,
        "allergies": allergies,
        "specialNeeds": specialNeeds,
        "medicalConditions": medicalConditions,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
