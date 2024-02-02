import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class GuardianMapScreen extends ConsumerStatefulWidget {
  const GuardianMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GuardianMapScreenState();
}

class _GuardianMapScreenState extends ConsumerState<GuardianMapScreen> {
  final bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();

    _initNaverMap();
  }

  void _initNaverMap() async {
    final bool isLocationPermissionGranted =
        ref.read(locationPermissionProvider.notifier).state;

    if (isLocationPermissionGranted) {
      await NaverMapSdk.instance.initialize(
        clientId: "3emvinr9f6",
        onAuthFailed: (ex) {
          print("********* 네이버맵 인증오류 : $ex *********");
        },
      );

      setState(() {});
    } else {
      print('위치 권한이 없습니다.');
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
              options: const NaverMapViewOptions(
                mapType: NMapType.basic,
                indoorEnable: true,
              ), // 지도 옵션을 설정할 수 있습니다.
              forceGesture:
                  false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
              onMapReady: (controller) {},
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {},
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
