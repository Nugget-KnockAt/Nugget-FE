import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/common/utils/account_validate.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';
import 'package:nugget/features/member/views/camera_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  final Dio _dio = Dio();

  bool _isEmailAvailable = false;

  @override
  void dispose() {
    // Dispose the controller when the state is disposed
    _passwordController.dispose();
    super.dispose();
  }

  void _onTapSignUpButton() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_formData);

      final String email = _formData['email'].toString();
      final String password = _formData['password'].toString();
      final String name = _formData['name'].toString();
      final String phoneNumber = _formData['phone'].toString();
      final UserType userType = ref.read(userInfoViewModelProvider).userType;

      // Perform the POST request to sign up
      try {
        final response = await _dio.post(
          '$commonUrl/member/signUp',
          data: {
            'email': email,
            'password': password,
            'name': name,
            'phoneNumber': phoneNumber,
            'role':
                userType == UserType.member ? 'ROLE_MEMBER' : 'ROLE_GUARDIAN',
          },
        );

        print(response.statusCode);
        print('result: ${response.data}');
        if (response.statusCode == 200) {
          // 사용자 정보 state update
          ref.read(userInfoViewModelProvider.notifier).updateUserInfo(
                uuid: response.data['result']['uuid'],
                userType: userType,
                username: name,
                phoneNumber: phoneNumber,
                email: email,
              );

          print('state에 사용자 정보 업데이트 완료');

          // 회원가입이 완료되었으면 사용자 정보를 기기에 저장한다.
          await storage.write(
              key: USER_UUID_KEY, value: response.data['result']['uuid']);
          await storage.write(key: USERNAME_KEY, value: name);
          await storage.write(key: USER_EMAIL_KEY, value: email);
          await storage.write(key: USER_PHONE_KEY, value: phoneNumber);
          await storage.write(
            key: USER_TYPE_KEY,
            value: userType.toString(),
          );

          // 회원가입이 완료되었으면 사용자의 토큰을 기기에 저장한다.
          await storage.write(
              key: ACCESS_TOKEN_KEY,
              value: response.data['result']['accessToken']);
          await storage.write(
              key: REFRESH_TOKEN_KEY,
              value: response.data['result']['refreshToken']);

          // 회원가입이 완료되었으면 사용자의 타입 (member, guardian)에 따라 다른 화면으로 이동한다.
          if (ref.read(userInfoViewModelProvider).userType == UserType.member) {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
              (route) => false,
            );
          } else {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const GuardianMapScreen()),
              (route) => false,
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('회원가입에 실패했습니다: ${response.data['message']}')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 중 오류가 발생했습니다: ${e.toString()}')),
        );
      }
    }
  }

  // 이메일 중복확인을 위한 함수
  void _checkEmailDuplicate() async {
    if (validateEmail(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 형식이 올바르지 않습니다'),
        ),
      );
      return;
    }
    // 이메일 중복확인을 위한 GET request
    final res = await _dio.get(
      '$commonUrl/member/checkEmail',
      queryParameters: {
        'email': _emailController.text,
      },
    );
    final resultBoolean = res.data['result'].toString();
    print('resultBoolean: $resultBoolean');

    if (res.statusCode == 200) {
      if (resultBoolean == 'true') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용 가능한 이메일입니다')),
        );

        _isEmailAvailable = true;
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미 사용 중인 이메일입니다'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userInfoViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gaps.v16,
                  const Text('아이디(이메일)'),
                  TextFormField(
                    controller: _emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      validateEmail(value);

                      if (_isEmailAvailable == false) {
                        return '이메일 중복확인을 해주세요';
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      _formData['email'] = newValue!;
                    },
                    decoration: InputDecoration(
                      hintText: '아이디(이메일)를 입력해주세요',
                      suffixIcon: ElevatedButton(
                        onPressed: _checkEmailDuplicate,
                        child: const Text('중복확인'),
                      ),
                    ),
                  ),
                  const Text('비밀번호'),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (newValue) {
                      _formData['password'] = newValue!;
                    },
                    validator: validatePassword,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해주세요',
                    ),
                  ),
                  const Text('비밀번호 확인'),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 다시 입력해주세요',
                    ),
                  ),
                  Gaps.v16,
                  const Text('이름'),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    onSaved: (newValue) {
                      _formData['name'] = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '이름(본명)을 입력해주세요',
                    ),
                  ),
                  const Text('휴대폰 번호'),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    onSaved: (newValue) {
                      _formData['phone'] = newValue!;
                    },
                    validator: (value) {
                      final phoneRegExp =
                          RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$');
                      if (value == null || value.isEmpty) {
                        return '휴대폰 번호를 입력해주세요';
                      }

                      if (!phoneRegExp.hasMatch(value)) {
                        return '휴대폰 번호 형식이 올바르지 않습니다';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '휴대폰 번호를 입력해주세요',
                    ),
                  ),
                  Gaps.v16,
                  const Text('어떤 자격이십니까?'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text('시각 장애인'),
                          value: UserType.member,
                          groupValue: state.userType,
                          onChanged: (UserType? value) {
                            ref
                                .read(userInfoViewModelProvider.notifier)
                                .updateUserType(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text('보호자'),
                          value: UserType.guardian,
                          groupValue: state.userType,
                          onChanged: (UserType? value) {
                            ref
                                .read(userInfoViewModelProvider.notifier)
                                .updateUserType(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: _onTapSignUpButton,
            child: const Text(
              '회원가입',
              style: TextStyle(
                fontSize: Sizes.size24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
