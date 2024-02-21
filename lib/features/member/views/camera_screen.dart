import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';

import 'package:nugget/features/authentication/view_models/permission_view_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/member/isolate_helper_mixin.dart';

import 'package:nugget/features/member/views/touch_settings_screen.dart';

// yolo 에 필요한 import
//추가 import
import 'yolo.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

typedef Callback = void Function(List<dynamic> list, int h, int w);

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with IsolateHelperMixin {
  // 카메라 객체
  late CameraController _cameraController;
  FlutterTts flutterTts = FlutterTts();

  // 플래쉬 상태
  FlashMode _flashMode = FlashMode.off;

  // 카메라가 초기화 되었는지 확인하는 변수
  bool _isCameraInitialized = false;

  //추가
  int _frameCounter = 0; // 프레임 카운터 선언
  final int _frameThreshold = 120; // 처리 프레임 설정
  Interpreter? interpreter;
  bool _isEventavoke = false;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  @override
  void dispose() {
    // 카메라 컨트롤러를 해제한다.
    _cameraController.dispose();

    _cameraController.stopImageStream();
    interpreter?.close();

    super.dispose();
  }

  Future<void> _initTts() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.setLanguage('en-US');
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

      // 카메라 컨트롤러가 초기화되면 화면을 갱신한다.
      _isCameraInitialized = true;

      await _initTts();

      if (mounted) {
        setState(() {});
      }

      //추가
      Interpreter interpreter =
          await Interpreter.fromAsset('assets/models/yolov8n_float16.tflite');

      _cameraController.startImageStream((CameraImage cameraImage) async {
        _frameCounter++; // 프레임 카운터 증가
        if (_frameCounter >= _frameThreshold && !_isEventavoke) {
          // 프레임 카운터가 임계값에 도달했는지 확인
          _frameCounter = 0; // 프레임 카운터 리셋

          // Convert CameraImage to img.Image
          img.Image image = convertBGRA8888ToImage(cameraImage);

          try {
            List<String> indices = await Yolov8(image, interpreter); // 비동기 처리
            print(indices);

            if (indices.isNotEmpty) {
              await flutterTts.stop();
              await flutterTts.speak('There is $indices in front of you.');
            }
          } catch (e) {
            // 오류 처리
            print(e.toString());
          }
        }
      });
    } else {
      print('카메라 권한이 없습니다.');
    }
  }

  ///추가 convertBGRA8888ToImage
  // CameraImage (BGRA format) to img.Image conversion
  img.Image convertBGRA8888ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgLibImage =
        img.Image(width: width, height: height); // Create img.Image

    final bgra = image.planes[0].bytes;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int offset =
            (y * width + x) * 4; // BGRA8888 means 4 bytes per pixel
        final blue = bgra[offset];
        final green = bgra[offset + 1];
        final red = bgra[offset + 2];
        final alpha = bgra[offset + 3];

        imgLibImage.setPixelRgba(x, y, red, green, blue, alpha);
      }
    }

    return imgLibImage;
  }

  Future<Position> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    return position;
  }

  Future<void> _onTapFlash() async {
    if (_flashMode == FlashMode.off) {
      await _cameraController.setFlashMode(FlashMode.torch);
      _flashMode = FlashMode.torch;
    } else {
      await _cameraController.setFlashMode(FlashMode.off);
      _flashMode = FlashMode.off;
    }

    setState(() {});
  }

  void _onTapSettings() async {
    _isEventavoke = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const TouchSettingsScreen();
    }));
    _isEventavoke = false;
  }

  void _showEventDialog() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Event'),
          content: const Text('Event Sent'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDoubleTap() async {
    await flutterTts.stop();
    final Dio dio = Dio();

    final accessToken =
        ref.read(authProvider.notifier).state.value!.accessToken;
    print('accessToken: $accessToken');

    Position position = await _getCurrentLocation();

    final response = await dio.post(
      '$commonUrl/member/event',
      data: {
        'action': 'doubleTap',
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      },
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Double Tap Event Sent');

      _showEventDialog();
      await flutterTts.speak('Double Tap Event Sent');

      print(response.data['result']['guardianList']);
    } else {
      print('Failed to send double tap event');
    }
  }

  void _handleLongPress() async {
    await flutterTts.stop();
    final Dio dio = Dio();

    final accessToken =
        ref.read(authProvider.notifier).state.value!.accessToken;
    print('accessToken: $accessToken');

    Position position = await _getCurrentLocation();

    final response = await dio.post(
      '$commonUrl/member/event',
      data: {
        'action': 'longPress',
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      },
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Long Press Event Sent');

      _showEventDialog();
      await flutterTts.speak('Long Press Event Sent');

      print(response.data['result']['guardianList']);
    } else {
      print('Failed to send long press event');
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) async {
    await flutterTts.stop();
    final Dio dio = Dio();

    final accessToken =
        ref.read(authProvider.notifier).state.value!.accessToken;
    print('accessToken: $accessToken');

    Position position = await _getCurrentLocation();

    try {
      if (details.primaryDelta! > 30) {
        final response = await dio.post(
          '$commonUrl/member/event',
          data: {
            'action': 'dragDown',
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
          },
          options: Options(
            headers: {
              'Authorization': accessToken,
            },
          ),
        );

        if (response.statusCode == 200) {
          print('Drag Down Event Sent');
          _showEventDialog();
          await flutterTts.speak('Drag Down Event Sent');
        } else {
          print('Failed to send drag down event');
        }
      } else if (details.primaryDelta! < -30) {
        final response = await dio.post(
          '$commonUrl/member/event',
          data: {
            'action': 'dragUp',
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
          },
          options: Options(
            headers: {
              'Authorization': accessToken,
            },
          ),
        );

        if (response.statusCode == 200) {
          print('Drag Up Event Sent');
          _showEventDialog();
          await flutterTts.speak('Drag Up Event Sent');
        } else {
          print('Failed to send drag up event');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onVerticalDragUpdate: _handleDragUpdate,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _onTapSettings,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              Sizes.size10,
                            ),
                          ),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.gear,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                      Gaps.v16,
                      GestureDetector(
                        onTap: _onTapFlash,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              Sizes.size10,
                            ),
                          ),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              _flashMode == FlashMode.off
                                  ? FontAwesomeIcons.bolt
                                  : FontAwesomeIcons.solidLightbulb,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
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
