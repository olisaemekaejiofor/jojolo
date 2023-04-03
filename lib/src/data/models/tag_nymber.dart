class TagNumber {
  TagNumber({
    required this.general,
    required this.feeding,
    required this.illness,
    required this.careAndNourishment,
    required this.allergies,
    required this.breastfeeding,
    required this.genderPsychology,
    required this.total,
  });

  final int? general;
  final int? feeding;
  final int? illness;
  final int? careAndNourishment;
  final int? allergies;
  final int? breastfeeding;
  final int? genderPsychology;
  final int? total;

  factory TagNumber.fromJson(Map<String, dynamic> json) {
    return TagNumber(
      general: json["General"],
      feeding: json["Feeding"],
      illness: json["Illness"],
      careAndNourishment: json["Care and Nourishment"],
      allergies: json["Allergies"],
      breastfeeding: json["Breastfeeding"],
      genderPsychology: json["Gender psychology"],
      total: json["Total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "General": general,
        "Feeding": feeding,
        "Illness": illness,
        "Care and Nourishment": careAndNourishment,
        "Allergies": allergies,
        "Breastfeeding": breastfeeding,
        "Gender psychology": genderPsychology,
        "Total": total,
      };
}
