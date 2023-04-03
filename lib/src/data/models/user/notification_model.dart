class Notifications {
  bool pushNotification;
  bool emailNotification;
  bool smsNotification;

  Notifications({
    required this.pushNotification,
    required this.emailNotification,
    required this.smsNotification,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      pushNotification: json['pushNotification'],
      emailNotification: json['emailNotification'],
      smsNotification: json['smsNotification'],
    );
  }
}
