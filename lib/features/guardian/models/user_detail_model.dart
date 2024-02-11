class UserDetailModel {
  UserDetailModel({
    required this.uuid,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });
  final String uuid;
  final String email;
  final String name;
  final String phoneNumber;

  UserDetailModel copyWith({
    String? uuid,
    String? email,
    String? name,
    String? phoneNumber,
  }) {
    return UserDetailModel(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      uuid: json['uuid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }
}
