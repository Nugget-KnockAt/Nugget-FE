import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';

class UserInfoViewModel extends StateNotifier<UserInfoModel> {
  UserInfoViewModel()
      : super(UserInfoModel(
          username: '',
          phoneNumber: '',
          address: '',
          email: '',
          isOverFourteen: false,
          ageedToTermsOfUse: false,
          agreedToPrivacyPolicy: false,
          agreedToLocationService: false,
          agreedToAll: false,
        ));

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateIsOverFourteen(bool isOverFourteen) {
    state = state.copyWith(isOverFourteen: isOverFourteen);

    isAllAgreed();
  }

  void updateAgreedToTermsOfUse(bool agreedToTermsOfUse) {
    state = state.copyWith(ageedToTermsOfUse: agreedToTermsOfUse);

    isAllAgreed();
  }

  void updateAgreedToPrivacyPolicy(bool agreedToPrivacyPolicy) {
    state = state.copyWith(agreedToPrivacyPolicy: agreedToPrivacyPolicy);

    isAllAgreed();
  }

  void updateAgreedToLocationService(bool agreedToLocationService) {
    state = state.copyWith(agreedToLocationService: agreedToLocationService);

    isAllAgreed();
  }

  void isAllAgreed() {
    if (state.isOverFourteen &&
        state.ageedToTermsOfUse &&
        state.agreedToPrivacyPolicy &&
        state.agreedToLocationService) {
      state = state.copyWith(agreedToAll: true);
    }
    if (!state.isOverFourteen ||
        !state.ageedToTermsOfUse ||
        !state.agreedToPrivacyPolicy ||
        !state.agreedToLocationService) {
      state = state.copyWith(agreedToAll: false);
    }
  }

  void updateAgreedToAll(bool agreedToAll) {
    if (agreedToAll) {
      state = state.copyWith(
        agreedToAll: true,
        isOverFourteen: true,
        ageedToTermsOfUse: true,
        agreedToPrivacyPolicy: true,
        agreedToLocationService: true,
      );
    }
    if (!agreedToAll) {
      state = state.copyWith(
        agreedToAll: false,
        isOverFourteen: false,
        ageedToTermsOfUse: false,
        agreedToPrivacyPolicy: false,
        agreedToLocationService: false,
      );
    }
  }
}

final userInfoViewModelProvider =
    StateNotifierProvider<UserInfoViewModel, UserInfoModel>(
  (ref) {
    return UserInfoViewModel();
  },
);
