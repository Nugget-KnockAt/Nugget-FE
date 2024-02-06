import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/models/user_info_model.dart';
import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/authentication/views/login_screen.dart';
import 'package:nugget/features/authentication/views/sign_up_screen.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';
import 'package:nugget/features/member/views/camera_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = 'signup';
  static const String routeURL = '/sign-up';

  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    _checkToken();
    // _deleteToken();
  }

  void _deleteToken() async {
    await storage.delete(key: ACCESS_TOKEN_KEY);
    await storage.delete(key: REFRESH_TOKEN_KEY);
  }

  // 기기에 저장되어 있는 사용자의 정보를 가져오는 함수
  Future<void> _loadUserInfo() async {
    // 저장되어 있는 사용자 정보를 불러온다.
    final uuidStr = await storage.read(key: USER_UUID_KEY);
    final usernameStr = await storage.read(key: USERNAME_KEY);
    final emailStr = await storage.read(key: USER_EMAIL_KEY);
    final phoneNumberStr = await storage.read(key: USER_PHONE_KEY);
    final userTypeStr = await storage.read(key: USER_TYPE_KEY);

    // 저장되어 있는 userTypeStr을 UserType으로 변환
    // 저장되어 있는 값이 없으면 null
    final UserType? userType = userTypeStr == UserType.member.toString()
        ? UserType.member
        : userTypeStr == UserType.guardian.toString()
            ? UserType.guardian
            : null;

    if (uuidStr != null &&
        usernameStr != null &&
        emailStr != null &&
        phoneNumberStr != null &&
        userType != null) {
      // 사용자 정보를 업데이트한다.
      ref.read(userInfoViewModelProvider.notifier).updateUserInfo(
            uuid: uuidStr,
            userType: userType,
            username: usernameStr,
            phoneNumber: phoneNumberStr,
            email: emailStr,
          );

      print('This is loadUserInfo function');
      print(
          'uuidStr: ${ref.read(userInfoViewModelProvider.notifier).state.uuid}');
      print(
          'usernameStr: ${ref.read(userInfoViewModelProvider.notifier).state.username}');
      print(
          'emailStr: ${ref.read(userInfoViewModelProvider.notifier).state.email}');
      print(
          'phoneNumberStr: ${ref.read(userInfoViewModelProvider.notifier).state.phoneNumber}');
      print(
          'userType: ${ref.read(userInfoViewModelProvider.notifier).state.userType}');
    } else {
      // 사용자 정보가 없으면 로그인 화면으로 이동한다.
      print('사용자 정보가 없습니다.');
    }
  }

  Future<void> _initPermission() async {
    // 카메라와 마이크 권한 요청
    // 이 두 개는 세트임. 둘 중 하나라도 거부되면 사용자에게 알림창을 띄워야 함.
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();
    final locationPermission = await Permission.location.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final microphoneDenied = microphonePermission.isDenied ||
        microphonePermission.isPermanentlyDenied;

    if (!cameraDenied && !microphoneDenied) {
      ref.read(cameraPermissionProvider.notifier).state = true;
    } else {
      // 카메라와 마이크 권한이 거부되었을 때
      // 알림창을 띄워 사용자에게 권한을 허용하도록 요청한다.
      if (!mounted) return;

      // 알림창 띄움.
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Nugget앱을 사용하기 위해선 카메라와 마이크 권한이 반드시 필요합니다.'),
            content: const Text('카메라와 마이크 권한을 허용해주세요.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // 위치 권한이 허용되었는지 확인
    if (locationPermission.isGranted) {
      ref.read(locationPermissionProvider.notifier).state = true;
    } else {
      ref.read(locationPermissionProvider.notifier).state = false;
    }

    // 위치 권한이 거부되었을 때
    if (locationPermission.isDenied || locationPermission.isPermanentlyDenied) {
      // 알림창 띄움.
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Nugget앱을 사용하기 위해선 위치 권한이 반드시 필요합니다.'),
            content: const Text('위치 권한을 허용해주세요.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // access token, refresh token이 있는지 확인하는 함수
  // 토큰이 있으면 기기에 저장되어 있는 사용자 정보를 불러오고
  // 사용자의 타입에 따라 다른 화면으로 이동한다.
  void _checkToken() async {
    // 권한 요청
    await _initPermission();

    // access token, refresh token이 있는지 확인
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    print('accessToken: $accessToken');
    print('refreshToken: $refreshToken');

    // refresh token이 없으면 혹은 access token이 없으면 로그인 화면 그대로 둔다.
    if (refreshToken == null ||
        refreshToken.isEmpty ||
        accessToken == null ||
        accessToken.isEmpty) {
      return;
    }

    // refresh token이 있으면 지금 상황에서는
    // access token 기간이 기니까
    // 그냥 access token을 사용하면 된다.

    // access token이 있으면 이미 사용자가 로그인 되어있다는 뜻이므로
    // 기기에 저장되어 있는 사용자의 정보를 로드한다.

    try {
      await _loadUserInfo();

      // 사용자의 타입에 따라 다른 화면으로 이동한다.
      final UserType userType =
          ref.read(userInfoViewModelProvider.notifier).state.userType;

      print('userType: $userType');

      // 사용자의 타입이 member이면 카메라 화면으로 이동
      if (userType == UserType.member) {
        // 회원 계정으로 로그인한 경우
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
          (route) => false,
        );
      }
      // 사용자의 타입이 guardian이면 보호자 맵 화면으로 이동
      else if (userType == UserType.guardian) {
        // 보호자 계정으로 로그인한 경우
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const GuardianMapScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  final Dio dio = Dio();

  @override
  Widget build(BuildContext contex) {
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
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              50,
                            ),
                            textStyle: Theme.of(context).textTheme.bodyLarge),
                        child: const Text('Sign In'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge, // 너비를 최대로, 높이는 50으로 설정
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
