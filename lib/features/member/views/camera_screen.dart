import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/member/views/touch_settings_screen.dart';

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

  // 카메라가 초기화 되었는지 확인하는 변수
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  @override
  void dispose() {
    // 카메라 컨트롤러를 해제한다.
    _cameraController.dispose();

    super.dispose();
  }

  // 카메라 초기화
  void _initCamera() async {
    final bool isCameraPermissionGranted =
        ref.read(cameraPermissionProvider.notifier).state;

    // 사용자가 카메라 권한을 허용했는지 확인
    if (isCameraPermissionGranted) {
      // 사용 가능한 카메라들 목록을 가져온다.
      final cameras = await availableCameras();

      // 후면 카메라를 사용한다.
      if (cameras.isEmpty) {
        print('사용 가능한 카메라가 없습니다.');

        return;
      }
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
    } else {
      print('카메라 권한이 없습니다.');
    }
  }

  void _onTapSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const CameraSettingsScreen();
    }));
  }

  void _handleDoubleTap() {
    print('Double Tap');
  }

  void _handleLongPress() {
    print('Long Press');
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
                Positioned.fill(
                  child: GestureDetector(
                    onDoubleTap: _handleDoubleTap,
                    onLongPress: _handleLongPress,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
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
                        },
                      );
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
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: _onTapSettings,
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
                          FontAwesomeIcons.gear,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
