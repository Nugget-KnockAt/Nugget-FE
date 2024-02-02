import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class GuardianMapScreen extends ConsumerStatefulWidget {
  const GuardianMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GuardianMapScreenState();
}

class _GuardianMapScreenState extends ConsumerState<GuardianMapScreen> {
  bool _hasPermission = false;
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();

    _initPermission();
  }

  void _initPermission() async {
    // 위치 권한 요청
    final locationPermission = Permission.location.request();

    // 위치 권한이 허용되었는지 확인
    if (await locationPermission.isGranted) {
      // 허용되었으면 true
      _hasPermission = true;

      // 네이버맵 초기화
      await _initNaverMap();
      _isMapInitialized = true;
      if (mounted) {
        setState(() {});
      }
    } else {
      // 허용되지 않았으면 false
      _hasPermission = false;
    }
  }

  Future<void> _initNaverMap() async {
    await NaverMapSdk.instance.initialize(
      clientId: "3emvinr9f6",
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Map'),
      ),
      body: _isMapInitialized
          ? NaverMap(
              options: const NaverMapViewOptions(),
              onMapReady: (controller) {
                print("네이버 맵 로딩됨!");
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
