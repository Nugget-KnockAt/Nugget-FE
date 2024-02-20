import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/common/utils/convert_between_string_liststring.dart';
import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/authentication/views/home_screen.dart';
import 'package:nugget/features/guardian/models/event_model.dart';
import 'package:nugget/features/guardian/view_models/event_view_model.dart';
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

  final Set<Marker> _markers = {};

  void _updateMarkers(List<EventModel> events) {
    _markers.clear();
    for (var event in events) {
      final marker = Marker(
        markerId: MarkerId(event.eventId.toString()),
        position: LatLng(event.latitude, event.longitude),
        infoWindow:
            InfoWindow(title: event.memberEmail, snippet: event.locationInfo),
      );
      _markers.add(marker);
    }
  }

  @override
  void initState() {
    super.initState();

    _initNaverMap();
    _initSseConnection();
  }

  Future<void> _getCurrentLocation() async {
    _initialPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print('위치: $_initialPosition');
    setState(() {});
  }

  // TODO: 이벤트 수신을 위한 SSE 연결을 초기화합니다.
  void _initSseConnection() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: '$commonUrl/member/sse-connect',
        header: {
          "Authorization": accessToken ?? '',
        }).listen(
      (event) {
        final eventData = parseMultipleJson(event.data!);

        if (event.event != 'connect') {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Message'),
                content: Text('${eventData[1]['text']}'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
    print('SSE 연결 완료');
  }

  void _initNaverMap() async {
    final bool isLocationPermissionGranted =
        ref.read(locationPermissionProvider.notifier).state;

    print('위치 권한: $isLocationPermissionGranted');

    if (isLocationPermissionGranted) {
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
    final eventsState = ref.watch(eventViewModelProvider);

    _updateMarkers(eventsState); // 마커 갱신
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Map'),
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // 로그아웃 처리
              await ref.read(authProvider.notifier).signOut();

              // 홈 화면으로 이동
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
              ? // 구글지도 추가
              GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_initialPosition!.latitude,
                        _initialPosition!.longitude),
                    zoom: 16,
                  ),
                  markers: _markers, // 마커 추가
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
                      final String memberEmail = settings.arguments as String;
                      return MaterialPageRoute(
                        builder: (context) => EventsListScreen(
                          scrollController: scrollController,
                          memberEmail: memberEmail,
                        ),
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
