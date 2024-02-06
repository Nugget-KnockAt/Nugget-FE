import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';

final userInfoViewModelProvider =
    StateNotifierProvider<UserInfoViewModel, UserInfoModel>(
  (ref) {
    return UserInfoViewModel();
  },
);

class UserInfoViewModel extends StateNotifier<UserInfoModel> {
  UserInfoViewModel()
      : super(
          UserInfoModel(
            uuid: '',
            userType: UserType.member,
            username: '',
            phoneNumber: '',
            email: '',
          ),
        );

  void updateUserUuid(String uuid) {
    state = state.copyWith(uuid: uuid);
  }

  void updateUserInfo({
    required String uuid,
    required UserType userType,
    required String username,
    required String phoneNumber,
    required String email,
  }) {
    state = state.copyWith(
      uuid: uuid,
      userType: userType,
      username: username,
      phoneNumber: phoneNumber,
      email: email,
    );
  }

  void updateUserType(UserType userType) {
    state = state.copyWith(userType: userType);
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void clearUserInfo() {
    state = state.copyWith(
      uuid: '',
      userType: UserType.member,
      username: '',
      phoneNumber: '',
      email: '',
    );
  }
}
