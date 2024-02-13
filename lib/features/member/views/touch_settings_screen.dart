import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';

import 'package:nugget/features/member/view_models/touch_settings_view_model.dart';

class CameraSettingsScreen extends ConsumerStatefulWidget {
  const CameraSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CameraSettingsScreenState();
}

class _CameraSettingsScreenState extends ConsumerState<CameraSettingsScreen> {
  final TextEditingController _doubleTapController = TextEditingController();
  final TextEditingController _longPressController = TextEditingController();
  final TextEditingController _dragUpController = TextEditingController();
  final TextEditingController _dragDownController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _doubleTapController.addListener(() {
      print('Double Tap: ${_doubleTapController.text}');
    });
    _longPressController.addListener(() {
      print('Long Press: ${_longPressController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final textBoxWidth = MediaQuery.of(context).size.width * 0.25;

    final doubleTapSettingState = ref.watch(doubleTapSettingProvider);
    final longPressSettingState = ref.watch(longPressSettingProvider);
    final dragUpSettingState = ref.watch(dragUpSettingProvider);
    final dragDownSettingState = ref.watch(dragDownSettingProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Touch Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: Sizes.size60, // 하단에서부터의 거리
                left: 0,
                right: 0,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('Log Out')),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: textBoxWidth,
                            child: Text(
                              'Double Tap',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gaps.h16,
                          Expanded(
                            child: TextField(
                              controller: _doubleTapController
                                ..text = doubleTapSettingState.when(
                                  data: (data) => data.text,
                                  loading: () => 'loading...',
                                  error: (error, stackTrace) => '',
                                ),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Enter your message',
                                labelStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gaps.v16,
                      Row(
                        children: [
                          SizedBox(
                            width: textBoxWidth,
                            child: Text(
                              'Long Press',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gaps.h16,
                          Expanded(
                            child: TextField(
                              controller: _longPressController
                                ..text = longPressSettingState.when(
                                  data: (data) => data.text,
                                  loading: () => 'loading...',
                                  error: (error, stackTrace) => '',
                                ),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Enter your message',
                                labelStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gaps.v16,
                      Row(
                        children: [
                          SizedBox(
                            width: textBoxWidth,
                            child: Text(
                              'Drag Up',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gaps.h16,
                          Expanded(
                            child: TextField(
                              controller: _dragUpController
                                ..text = dragUpSettingState.when(
                                  data: (data) => data.text,
                                  loading: () => 'loading...',
                                  error: (error, stackTrace) => '',
                                ),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Enter your message',
                                labelStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gaps.v16,
                      Row(
                        children: [
                          SizedBox(
                            width: textBoxWidth,
                            child: Text(
                              'Drag Down',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gaps.h16,
                          Expanded(
                            child: TextField(
                              controller: _dragDownController
                                ..text = dragDownSettingState.when(
                                  data: (data) => data.text,
                                  loading: () => 'loading...',
                                  error: (error, stackTrace) => '',
                                ),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Enter your message',
                                labelStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gaps.v32,
                      ElevatedButton(
                          onPressed: () async {
                            // 데이터 저정
                            await ref
                                .read(touchSettingsNotifierProvider.notifier)
                                .saveDoubleTapSetting(
                                  _doubleTapController.text,
                                );

                            await ref
                                .read(touchSettingsNotifierProvider.notifier)
                                .saveLongPressSetting(
                                  _longPressController.text,
                                );

                            await ref
                                .read(touchSettingsNotifierProvider.notifier)
                                .saveDragUpSetting(
                                  _dragUpController.text,
                                );

                            await ref
                                .read(touchSettingsNotifierProvider.notifier)
                                .saveDragDownSetting(
                                  _dragDownController.text,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              50,
                            ),
                          ),
                          child: const Text('Save'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
