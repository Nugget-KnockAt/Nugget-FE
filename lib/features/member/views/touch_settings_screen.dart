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
  final GlobalKey<_TouchSettingMessageState> threeTouchKey = GlobalKey();
  final GlobalKey<_TouchSettingMessageState> fourTouchKey = GlobalKey();
  final GlobalKey<_TouchSettingMessageState> fiveTouchKey = GlobalKey();
  final GlobalKey<_TouchSettingMessageState> sixTouchKey = GlobalKey();

  Future<void> _loadSettings() {
    final viewModel = ref.read(touchSettingsViewModelProvider.notifier);
    return viewModel.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Touch Settings'),
              ),
              body: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TouchSettingMessage(
                        key: threeTouchKey,
                        message: '3 Touches',
                        state: ref
                                .read(touchSettingsViewModelProvider.notifier)
                                .state
                                .threeTouches ??
                            '',
                      ),
                      Gaps.v16,
                      TouchSettingMessage(
                        key: fourTouchKey,
                        message: '4 Touches',
                        state: ref
                                .read(touchSettingsViewModelProvider.notifier)
                                .state
                                .fourTouches ??
                            '',
                      ),
                      Gaps.v16,
                      TouchSettingMessage(
                        key: fiveTouchKey,
                        message: '5 Touches',
                        state: ref
                                .read(touchSettingsViewModelProvider.notifier)
                                .state
                                .fiveTouches ??
                            '',
                      ),
                      Gaps.v16,
                      TouchSettingMessage(
                        key: sixTouchKey,
                        message: '6 Touches',
                        state: ref
                                .read(touchSettingsViewModelProvider.notifier)
                                .state
                                .sixTouches ??
                            '',
                      ),
                      Gaps.v32,
                      ElevatedButton(
                        onPressed: () {
                          final viewModel =
                              ref.read(touchSettingsViewModelProvider.notifier);
                          viewModel.updateThreeTouches(
                              threeTouchKey.currentState?.currentText ?? '');
                          viewModel.updateFourTouches(
                              fourTouchKey.currentState?.currentText ?? '');
                          viewModel.updateFiveTouches(
                              fiveTouchKey.currentState?.currentText ?? '');
                          viewModel.updateSixTouches(
                              sixTouchKey.currentState?.currentText ?? '');
                          viewModel.saveAllSettings();
                          print('Settings Saved');
                        },
                        child: const Text('Save'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TouchSettingMessage extends ConsumerStatefulWidget {
  const TouchSettingMessage({
    super.key,
    required this.message,
    required this.state,
  });

  final String message;
  final String state;

  @override
  ConsumerState<TouchSettingMessage> createState() =>
      _TouchSettingMessageState();
}

class _TouchSettingMessageState extends ConsumerState<TouchSettingMessage> {
  final TextEditingController _controller = TextEditingController();

  String get currentText => _controller.text;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.state;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.message,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Gaps.h16,
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              filled: false,
              hintText: 'Enter your message',
              labelStyle: Theme.of(context).textTheme.labelLarge,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: Sizes.size10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
