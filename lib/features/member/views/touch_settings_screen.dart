import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/authentication/views/home_screen.dart';
import 'package:nugget/features/member/view_models/touch_action_view_model.dart';

class TouchSettingsScreen extends ConsumerStatefulWidget {
  const TouchSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TouchSettingsScreenState();
}

class _TouchSettingsScreenState extends ConsumerState<TouchSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _doubleTapController = TextEditingController();
  final TextEditingController _longPressController = TextEditingController();
  final TextEditingController _dragUpController = TextEditingController();
  final TextEditingController _dragDownController = TextEditingController();

  String _doubleTapText = '';
  String _longPressText = '';
  String _dragUpText = '';
  String _dragDownText = '';

  @override
  void initState() {
    super.initState();

    _doubleTapController.text = _doubleTapText;
    _longPressController.text = _longPressText;
    _dragUpController.text = _dragUpText;
    _dragDownController.text = _dragDownText;

    _doubleTapController.addListener(() {
      _doubleTapText = _doubleTapController.text;
    });

    _longPressController.addListener(() {
      _longPressText = _longPressController.text;
    });

    _dragUpController.addListener(() {
      _dragUpText = _dragUpController.text;
    });

    _dragDownController.addListener(() {
      _dragDownText = _dragDownController.text;
    });
  }

  @override
  void dispose() {
    _doubleTapController.dispose();
    _longPressController.dispose();
    _dragUpController.dispose();
    _dragDownController.dispose();

    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await ref
          .read(doubleTapActionProvider.notifier)
          .saveTouchAction(_doubleTapText);

      await ref
          .read(longPressActionProvider.notifier)
          .saveTouchAction(_longPressText);

      await ref
          .read(dragUpActionProvider.notifier)
          .saveTouchAction(_dragUpText);

      await ref
          .read(dragDownActionProvider.notifier)
          .saveTouchAction(_dragDownText);

      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Save Complete'),
            content: const Text('Your settings have been saved.'),
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
  }

  @override
  Widget build(BuildContext context) {
    final textBoxWidth = MediaQuery.of(context).size.width * 0.25;

    final doubleTapActionState = ref.watch(doubleTapActionProvider);
    final longPressActionState = ref.watch(longPressActionProvider);
    final dragUpActionState = ref.watch(dragUpActionProvider);
    final dragDownActionState = ref.watch(dragDownActionProvider);

    doubleTapActionState.when(
      data: (touchAction) {
        if (_doubleTapText.isEmpty) {
          // Only set the text if it's empty
          _doubleTapText = touchAction.text;
          _doubleTapController.text = _doubleTapText;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );

    longPressActionState.when(
      data: (touchAction) {
        if (_longPressText.isEmpty) {
          // Only set the text if it's empty
          _longPressText = touchAction.text;
          _longPressController.text = _longPressText;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );

    dragUpActionState.when(
      data: (touchAction) {
        if (_dragUpText.isEmpty) {
          // Only set the text if it's empty
          _dragUpText = touchAction.text;
          _dragUpController.text = _dragUpText;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );

    dragDownActionState.when(
      data: (touchAction) {
        if (_dragDownText.isEmpty) {
          // Only set the text if it's empty
          _dragDownText = touchAction.text;
          _dragDownController.text = _dragDownText;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    onPressed: () async {
                      // 로그아웃

                      await ref.read(authProvider.notifier).signOut();

                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
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
                  child: Form(
                    key: _formKey,
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
                              child: TextFormField(
                                controller: _doubleTapController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _doubleTapText = value!;
                                },
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
                              child: TextFormField(
                                controller: _longPressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _longPressText = value!;
                                },
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
                              child: TextFormField(
                                controller: _dragUpController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _dragUpText = value!;
                                },
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
                              child: TextFormField(
                                controller: _dragDownController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _dragDownText = value!;
                                },
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
                            onPressed: _onSave,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
