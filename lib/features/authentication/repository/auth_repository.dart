import 'package:dio/dio.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/models/user_info_from_email_model.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<UserInfoModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$commonUrl/member/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final userInfo = UserInfoModel.fromJson(response.data['result']);
      return userInfo;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<UserInfoModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required Role role,
  }) async {
    try {
      final response = await _dio.post(
        '$commonUrl/member/signup',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phoneNumber': phoneNumber,
          'role': role.name,
        },
      );

      final userInfo = UserInfoModel.fromJson(response.data['result']);
      return userInfo;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> storeUserInfoIntoDevice({
    required String email,
    required String password,
    required String accessToken,
    required String refreshToken,
  }) async {
    /* 
    *  로그인 성공 시, 사용자의 토큰을 기기에 저장한다.
     */
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

    /* 
    *  로그인 성공 시, 사용자의 이메일과 비밀번호를 기기에 저장한다.
     */

    await storage.write(key: USER_EMAIL_KEY, value: email);
    await storage.write(key: USER_PW_KEY, value: password);
  }

  Future<void> removeUserInfoFromDevice() async {
    await storage.delete(key: ACCESS_TOKEN_KEY);
    await storage.delete(key: REFRESH_TOKEN_KEY);
    await storage.delete(key: USER_EMAIL_KEY);
    await storage.delete(key: USER_PW_KEY);
  }

  Future<UserInfoFromEmailModel> getUserInfoByEmail(String email) async {
    try {
      final response = await _dio.get(
        '$commonUrl/member/info',
        queryParameters: {
          'email': email,
        },
      );

      final userInfo = UserInfoFromEmailModel.fromJson(response.data['result']);

      return userInfo;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> connectMember(String email) async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await _dio.post(
        '$commonUrl/member/connect',
        options: Options(headers: {
          'Authorization': accessToken,
        }),
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['is_success'] == false) {
          throw Exception(response.data['message']);
        }
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
