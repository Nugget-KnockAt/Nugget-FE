class UserInfoFromEmailModel {
  final String uuid;
  final String email;
  final String name;
  final String phoneNumber;

  UserInfoFromEmailModel({
    required this.uuid,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  factory UserInfoFromEmailModel.fromJson(Map<String, dynamic> json) {
    return UserInfoFromEmailModel(
      uuid: json['uuid'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
