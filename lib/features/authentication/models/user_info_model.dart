class UserInfoModel {
  String username;
  String phoneNumber;
  String address;
  String email;

  // 약관 동의 내용
  bool isOverFourteen;
  bool ageedToTermsOfUse;
  bool agreedToPrivacyPolicy;
  bool agreedToLocationService;
  bool agreedToAll;

  UserInfoModel({
    required this.username,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isOverFourteen,
    required this.ageedToTermsOfUse,
    required this.agreedToPrivacyPolicy,
    required this.agreedToLocationService,
    required this.agreedToAll,
  });

  UserInfoModel copyWith({
    String? username,
    String? phoneNumber,
    String? address,
    String? email,
    bool? isOverFourteen,
    bool? ageedToTermsOfUse,
    bool? agreedToPrivacyPolicy,
    bool? agreedToLocationService,
    bool? agreedToAll,
  }) {
    return UserInfoModel(
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      isOverFourteen: isOverFourteen ?? this.isOverFourteen,
      ageedToTermsOfUse: ageedToTermsOfUse ?? this.ageedToTermsOfUse,
      agreedToPrivacyPolicy:
          agreedToPrivacyPolicy ?? this.agreedToPrivacyPolicy,
      agreedToLocationService:
          agreedToLocationService ?? this.agreedToLocationService,
      agreedToAll: agreedToAll ?? this.agreedToAll,
    );
  }
}
