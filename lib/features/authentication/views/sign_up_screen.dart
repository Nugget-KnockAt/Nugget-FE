import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/authentication/views/widgets/login_button.dart';
import 'package:nugget/features/camera/views/camera_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  String? _userToken;

  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();

  // Kakao OAuth configuration
  final clientId = 'b721de5fbf402ff1131e42e1ce771b92';
  final redirectUri = 'http://52.79.220.245:8080/login/oauth2/kakao/callback';
  final authorizationUrl = 'https://kauth.kakao.com/oauth/authorize';

  @override
  void initState() {
    super.initState();

    // 유저 토큰을 가져옴.
    _getUserToken();
  }

  void _getUserToken() async {
    _userToken = await storage.read(key: 'ACCESS_TOKEN');
    if (_userToken != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _onTapUserKakaoLoginButton(BuildContext context) async {}

  @override
  Widget build(BuildContext contex) {
    void onTapGuardian() {
      showModalBottomSheet(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 400,
        ),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size32),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginButton(
                  iconPath: 'assets/icons/kakao.svg',
                  text: 'Continue with Kakao',
                  color: Color(0xfff8df02),
                ),
                Gaps.v12,
                LoginButton(
                  iconPath: 'assets/icons/google.svg',
                  text: 'Continue with Google',
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/logo/nugget_transparent_logo_without_name.png',
              ),
            ),
            Positioned(
              bottom: Sizes.size20,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _onTapUserKakaoLoginButton(context),
                    child: const LoginButton(
                      iconPath: 'assets/icons/kakao.svg',
                      text: 'Continue with Kakao',
                      color: Color(0xfff8df02),
                    ),
                  ),
                  Gaps.v12,
                  const LoginButton(
                    iconPath: 'assets/icons/google.svg',
                    text: 'Continue with Google',
                    color: Colors.white,
                  ),
                  Gaps.v28,
                  GestureDetector(
                    onTap: onTapGuardian,
                    child: Text(
                      '보호자이신가요?',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
