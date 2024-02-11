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
  List<String> connectionList;

  UserInfoModel({
    required this.uuid,
    required this.userType,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.connectionList,
  });

  UserInfoModel copyWith({
    String? uuid,
    UserType? userType,
    String? username,
    String? phoneNumber,
    String? email,
    List<String>? connectionList,
  }) {
    return UserInfoModel(
      uuid: uuid ?? this.uuid,
      userType: userType ?? this.userType,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      connectionList: connectionList ?? this.connectionList,
    );
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      uuid: json['uuid'] ?? '',
      userType:
          json['role'] == 'ROLE_MEMBER' ? UserType.member : UserType.guardian,
      username: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      connectionList:
          List<String>.from(json['connectionList'].map((x) => x.toString())),
    );
  }
}
