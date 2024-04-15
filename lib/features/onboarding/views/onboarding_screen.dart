import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/member/views/camera_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  String _displayText = "";
  int _charIndex = 0;
  Timer? _timer;
  final String _fullText =
      "Hello there! My name is Buddy, and I'm here to be your trusty guide. With my keen senses and cheerful spirit, I'll help you navigate every step of the way. You can count on me to be by your side, making sure you feel secure and confident as we go on our walks together. Just hold onto my leash, and we'll tackle all our adventures with a wag and a smile!";

  @override
  void initState() {
    super.initState();
    _startDisplayText();
    _playAudio();
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _startDisplayText() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 70),
      (timer) {
        if (_charIndex < _fullText.length) {
          setState(() {
            _displayText += _fullText[_charIndex];
            _charIndex++;
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  Future<void> _playAudio() async {
    await audioPlayer.play(AssetSource('sounds/hello_there.wav'));
  }

  void _navigateToCameraScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Nugget!'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size20,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 300,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: width * 0.7,
                    maxWidth: width * 0.7,
                    minHeight: height * 0.3,
                    maxHeight: height * 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size20,
                    vertical: Sizes.size10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                      color: Colors.black,
                      width: Sizes.size1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Sizes.size20),
                      topRight: Radius.circular(Sizes.size20),
                      bottomRight: Radius.circular(Sizes.size20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey.shade400,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    _displayText,
                    style: const TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/images/onboarding_image_transparent.png',
                  width: width * 0.7,
                ),
              ),
              Positioned(
                bottom: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size20,
                      vertical: Sizes.size10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.size20),
                    ),
                    minimumSize: Size(width * 0.7, Sizes.size60),
                  ),
                  onPressed: _navigateToCameraScreen,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
