import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  // 카메라 객체
  late CameraController _cameraController;

  // 플래쉬 상태
  late final FlashMode _flashMode;

  // 카메라와 마이크 권한이 허용되었는지 확인하는 변수
  // 두 개 모두 허용되었을 때 true
  bool _hasPermission = false;

  // 카메라가 초기화 되었는지 확인하는 변수
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();

    _initPermission();
  }

  @override
  void dispose() {
    // 카메라 컨트롤러를 해제한다.
    _cameraController.dispose();

    super.dispose();
  }

  // 카메라 초기화
  Future<void> _initCamera() async {
    // 사용 가능한 카메라들 목록을 가져온다.
    final cameras = await availableCameras();

    // 후면 카메라를 사용한다.
    final firstCamera = cameras.first;

    // 카메라 컨트롤러를 초기화한다.
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.ultraHigh,
    );

    // 카메라 컨트롤러 시작.
    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;

    // 카메라 컨트롤러가 초기화되면 화면을 갱신한다.
    _isCameraInitialized = true;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initPermission() async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final microphoneDenied = microphonePermission.isDenied ||
        microphonePermission.isPermanentlyDenied;

    if (!cameraDenied && !microphoneDenied) {
      // 카메라와 마이크 권한이 허용되었을 때
      _hasPermission = true;
      await _initCamera();
    } else {
      // 카메라와 마이크 권한이 거부되었을 때
      if (!mounted) return;

      // 카메라와 마이크 권한을 허용하도록 알림창을 띄운다.
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
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userInfoViewModelProvider);

    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(
                    _cameraController,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('사용자 ID'),
                              content: Text(state.uuid),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          Sizes.size10,
                        ),
                      ),
                      width: 50,
                      height: 50,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.userPlus,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
