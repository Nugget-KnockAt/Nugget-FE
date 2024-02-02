enum UserType {
  member,
  guardian,
}

class UserInfoModel {
  UserType userType;
  String uuid;
  String username;
  String phoneNumber;
  String email;

  UserInfoModel({
    required this.uuid,
    required this.userType,
    required this.username,
    required this.phoneNumber,
    required this.email,
  });

  UserInfoModel copyWith({
    String? uuid,
    UserType? userType,
    String? username,
    String? phoneNumber,
    String? email,
  }) {
    return UserInfoModel(
      uuid: uuid ?? this.uuid,
      userType: userType ?? this.userType,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
}
