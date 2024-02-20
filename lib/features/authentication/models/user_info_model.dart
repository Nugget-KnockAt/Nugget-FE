enum Role {
  member,
  guardian,
}

class UserInfoModel {
  Role role;
  String uuid;
  String name;
  String phoneNumber;
  String email;
  String accessToken;
  String refreshToken;
  List<String> connectionList;

  UserInfoModel({
    required this.role,
    required this.uuid,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.connectionList,
  });

  UserInfoModel copyWith({
    Role? role,
    String? uuid,
    String? name,
    String? phoneNumber,
    String? email,
    String? accessToken,
    String? refreshToken,
    List<String>? connectionList,
  }) {
    return UserInfoModel(
      role: role ?? this.role,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      connectionList: connectionList ?? this.connectionList,
    );
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      role: json['role'] == 'ROLE_MEMBER' ? Role.member : Role.guardian,
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      connectionList: List<String>.from(json['connectionList'] ?? []),
    );
  }
}
