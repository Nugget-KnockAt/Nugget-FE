import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/common/utils/account_validate.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';
import 'package:nugget/features/member/views/camera_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Perform the POST request to sign up
      try {
        final response = await _dio.post(
          '$commonUrl/member/login', // Replace with your API endpoint
          data: {
            'email': email,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          final uuid = response.data['result']['uuid'];
          final username = response.data['result']['name'];
          final email = response.data['result']['email'];
          final phoneNumber = response.data['result']['phoneNumber'];
          final userType = response.data['result']['role'] == 'ROLE_MEMBER'
              ? UserType.member
              : UserType.guardian;

          // 로그인이 성공하면 사용자의 토큰 정보를 기기에 저장한다.
          await storage.write(
              key: ACCESS_TOKEN_KEY,
              value: response.data['result']['accessToken']);
          await storage.write(
              key: REFRESH_TOKEN_KEY,
              value: response.data['result']['refreshToken']);

          // 로그인이 성공하면 사용자의 정보를 기기에 저장한다.
          await storage.write(key: USER_UUID_KEY, value: uuid);
          await storage.write(key: USERNAME_KEY, value: username);
          await storage.write(key: USER_EMAIL_KEY, value: email);
          await storage.write(key: USER_PHONE_KEY, value: phoneNumber);
          await storage.write(key: USER_TYPE_KEY, value: userType.toString());

          // 사용자의 상태를 업데이트한다.
          ref.read(userInfoViewModelProvider.notifier).updateUserInfo(
                uuid: uuid,
                userType: userType,
                username: username,
                phoneNumber: phoneNumber,
                email: email,
              );

          // 사용자의 타입에 따라 다른 화면으로 이동한다.
          if (userType == UserType.member) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const GuardianMapScreen(),
              ),
              (route) => false,
            );
          }
          // Navigate or do something else
        } else {
          // Handle non-successful response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign up')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred during sign up')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Gaps.v52,
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: validateEmail,
              decoration: const InputDecoration(
                labelText: '이메일',
              ),
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
