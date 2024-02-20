import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nugget/features/authentication/models/user_info_from_email_model.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';
import 'package:nugget/features/authentication/repository/auth_repository.dart';

// provider
final authProvider = AsyncNotifierProvider<AuthNotifier, UserInfoModel>(() {
  final authRepository = AuthRepository();
  return AuthNotifier(authRepository);
});

final connectedUserInfoListProvider = AsyncNotifierProvider<
    ConnectedUserInfoListNotifier, List<UserInfoFromEmailModel>>(() {
  return ConnectedUserInfoListNotifier(AuthRepository());
});

// notifier
class AuthNotifier extends AsyncNotifier<UserInfoModel> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository);

  @override
  FutureOr<UserInfoModel> build() {
    return UserInfoModel(
      role: Role.member, // Or another appropriate default value
      uuid: '',
      name: '',
      phoneNumber: '',
      email: '',
      accessToken: '',
      refreshToken: '',
      connectionList: [],
    );
  }

  Future<UserInfoModel> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async =>
        await _authRepository.login(email: email, password: password));

    /* 
    *  로그인 성공 시, 사용자의 토큰을 기기에 저장한다.
     */
    await _authRepository.storeUserInfoIntoDevice(
      email: email,
      password: password,
      accessToken: state.value!.accessToken,
      refreshToken: state.value!.refreshToken,
    );

    return state.value!;
  }

  Future<UserInfoModel> signUp(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber,
      required Role role}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _authRepository.signUp(
          email: email,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
          role: role,
        ));

    await _authRepository.storeUserInfoIntoDevice(
      email: email,
      password: password,
      accessToken: state.value!.accessToken,
      refreshToken: state.value!.refreshToken,
    );

    return state.value!;
  }

  Future<void> signOut() async {
    await _authRepository.removeUserInfoFromDevice();
  }

  Future<void> connectMember(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final connectedMemberList = state.value!.connectionList;
      await _authRepository.connectMember(email);
      connectedMemberList.add(email);

      return state.value!.copyWith(connectionList: connectedMemberList);
    });

    print('Connected Member List: ${state.value!.connectionList}');
  }
}

class ConnectedUserInfoListNotifier
    extends AsyncNotifier<List<UserInfoFromEmailModel>> {
  final AuthRepository _authRepository;

  ConnectedUserInfoListNotifier(this._authRepository);

  @override
  FutureOr<List<UserInfoFromEmailModel>> build() async {
    final connectedMemberList = ref.watch(authProvider).value!.connectionList;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<List<UserInfoFromEmailModel>>(() async {
      return await Future.wait(
        connectedMemberList
            .map((e) => _authRepository.getUserInfoByEmail(e))
            .toList(),
      );
    });

    return state.value!;
  }
}
