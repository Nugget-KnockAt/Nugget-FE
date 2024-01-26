import 'package:flutter/material.dart';

import 'package:knock_at/constants/gaps.dart';
import 'package:knock_at/constants/sizes.dart';
import 'package:knock_at/features/authentication/views/widgets/kakao_login.dart';
import 'package:knock_at/features/authentication/views/widgets/login_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onTapKakaoLoginButton(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const KakaoLogin();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => _onTapKakaoLoginButton(context),
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
