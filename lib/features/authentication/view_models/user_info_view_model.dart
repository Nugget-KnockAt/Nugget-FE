import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knock_at/features/authentication/models/user_info_model.dart';

class UserInfoViewModel extends Notifier<UserInfoModel> {
  void setUsername(String username) {
    state = UserInfoModel(
      username: username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setPhoneNumber(String phoneNumber) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setAddress(String address) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setEmail(String email) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setIsOverFourteen(bool isOverFourteen) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setAgreedToTermsOfUse(bool agreedToTermsOfUse) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: agreedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setAgreedToPrivacyPolicy(bool agreedToPrivacyPolicy) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: agreedToPrivacyPolicy,
      agreedToLocationService: state.agreedToLocationService,
    );
  }

  void setAgreedToLocationService(bool agreedToLocationService) {
    state = UserInfoModel(
      username: state.username,
      phoneNumber: state.phoneNumber,
      address: state.address,
      email: state.email,
      isOverFourteen: state.isOverFourteen,
      ageedToTermsOfUse: state.ageedToTermsOfUse,
      agreedToPrivacyPolicy: state.agreedToPrivacyPolicy,
      agreedToLocationService: agreedToLocationService,
    );
  }

  @override
  UserInfoModel build() {
    return UserInfoModel(
      username: '',
      phoneNumber: '',
      address: '',
      email: '',
      isOverFourteen: false,
      ageedToTermsOfUse: false,
      agreedToPrivacyPolicy: false,
      agreedToLocationService: false,
    );
  }
}

final userInfoProvider = NotifierProvider<UserInfoViewModel, UserInfoModel>(
    () => UserInfoViewModel());
