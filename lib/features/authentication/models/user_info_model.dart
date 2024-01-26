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

  UserInfoModel({
    required this.username,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isOverFourteen,
    required this.ageedToTermsOfUse,
    required this.agreedToPrivacyPolicy,
    required this.agreedToLocationService,
  });
}
