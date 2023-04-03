class AuthUser {
  UserData userData;
  String userType;
  DataInch dataInch;

  AuthUser({
    required this.userType,
    required this.dataInch,
    required this.userData,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userType: json['userType'],
      dataInch: DataInch.fromJson(json['dataInch']),
      userData: UserData.fromJson(json['userData']),
    );
  }
}

class DataInch {
  String id;
  String fullName;
  String email;
  String? role;
  String? roleDescription;
  String? imageUrl;

  DataInch({
    required this.id,
    required this.fullName,
    required this.email,
    this.role,
    this.roleDescription,
    this.imageUrl,
  });

  factory DataInch.fromJson(Map<String, dynamic> data) {
    return DataInch(
      id: data['id'],
      fullName: data['fullName'],
      email: data['email'],
      role: data['role'],
      roleDescription: data['roleDescription'],
      imageUrl: data['imageUrl'],
    );
  }
}

class UserData {
  String token;
  String? doctorId;
  String? caregiverId;

  UserData({required this.token, this.doctorId, this.caregiverId});

  factory UserData.fromJson(Map<String, dynamic> userdata) {
    return UserData(
      token: userdata['token'],
      doctorId: userdata['doctorId'],
      caregiverId: userdata['caregiverId'],
    );
  }
}
