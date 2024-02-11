import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/authentication/views/home_screen.dart';
import 'package:nugget/features/guardian/views/events_list_screen.dart';
import 'package:nugget/features/guardian/views/member_list_screen.dart';

class GuardianMapScreen extends ConsumerStatefulWidget {
  const GuardianMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GuardianMapScreenState();
}

class _GuardianMapScreenState extends ConsumerState<GuardianMapScreen> {
  bool _isMapInitialized = false;

  Position? _initialPosition;

  @override
  void initState() {
    super.initState();

    _initNaverMap();
  }

  Future<void> _getCurrentLocation() async {
    _initialPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('위치: $_initialPosition');
    setState(() {});
  }

  void _initNaverMap() async {
    final bool isLocationPermissionGranted =
        ref.read(locationPermissionProvider.notifier).state;

    print('위치 권한: $isLocationPermissionGranted');

    if (isLocationPermissionGranted) {
      await NaverMapSdk.instance.initialize(
        clientId: "3emvinr9f6",
        onAuthFailed: (ex) {
          print("********* 네이버맵 인증오류 : $ex *********");
        },
      );
      await _getCurrentLocation();
      setState(() {
        _isMapInitialized = true;
      });
    } else {
      print('위치 권한이 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              ref.read(userInfoViewModelProvider.notifier).clearUserInfo();
              await storage.delete(key: ACCESS_TOKEN_KEY);
              await storage.delete(key: REFRESH_TOKEN_KEY);

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _isMapInitialized
              ? NaverMap(
                  options: NaverMapViewOptions(
                    mapType: NMapType.basic,
                    indoorEnable: true,
                    initialCameraPosition: _initialPosition != null
                        ? NCameraPosition(
                            target: NLatLng(_initialPosition!.latitude,
                                _initialPosition!.longitude),
                            zoom: 15,
                            bearing: 0,
                            tilt: 0,
                          )
                        : null,
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
          DraggableScrollableSheet(
            initialChildSize:
                0.3, // The initial height of the bottom sheet (30% of the screen height)
            minChildSize:
                0.3, // The minimum height of the bottom sheet when dragging down
            maxChildSize:
                0.9, // The maximum height of the bottom sheet when dragging up
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.size20),
                    topRight: Radius.circular(Sizes.size20),
                  ),
                ),
                child: Navigator(
                  onGenerateRoute: (settings) {
                    if (settings.name == '/') {
                      return MaterialPageRoute(
                        builder: (smallContext) => MemberListScreen(
                          scrollController: scrollController,
                          mainScreenContext: context,
                        ),
                      );
                    } else if (settings.name == '/events') {
                      return MaterialPageRoute(
                        builder: (context) => const EventsListScreen(),
                      );
                    }
                    assert(false, 'Need to implement ${settings.name}');
                    return null;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
